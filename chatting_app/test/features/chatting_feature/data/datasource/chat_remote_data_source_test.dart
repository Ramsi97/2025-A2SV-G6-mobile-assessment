import 'dart:async';
import 'dart:convert';

import 'package:chatting_app/core/constant/constant.dart';
import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/features/chatting_feature/data/datasource/chat_remote_data_source.dart';
import 'package:chatting_app/features/chatting_feature/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting_feature/data/model/message_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  late ChatRemoteDataSourceImpl remoteDataSourceImpl;
  late MockHttpClient mockHttpClient;
  late MockWebSocketChannel mockWebSocketChannel;
  late MockWebSocketSink mockWebSocketSink;

  setUp(() {
    mockWebSocketSink = MockWebSocketSink();
    mockWebSocketChannel = MockWebSocketChannel();
    mockHttpClient = MockHttpClient();

    when(() => mockWebSocketChannel.sink).thenReturn(mockWebSocketSink);

    remoteDataSourceImpl = ChatRemoteDataSourceImpl(
      client: mockHttpClient,
      channel: mockWebSocketChannel,
    );
  });

  // Register fallback values in your test setup
  setUpAll(() {
    registerFallbackValue(Uri.parse('$baseUrl/chats'));
    registerFallbackValue(
      <String, String>{},
    ); // for headers Map<String, String>
  });

  final tChatJson = {
    "id": "123",
    "user1": {"id": "user1", "name": "Alice", "email": "alice@example.com"},
    "user2": {"id": "user2", "name": "Bob", "email": "bob@example.com"},
  };
  final tChatModel = ChatModel.fromJson(tChatJson);
  final tMessageJsonList = [
    {
      "id": "1",
      "sender": {"id": "user1", "name": "Alice", "email": "alice@example.com"},
      "chat": {
        "id": "123",
        "user1": {"id": "user1", "name": "Alice", "email": "alice@example.com"},
        "user2": {"id": "user2", "name": "Bob", "email": "bob@example.com"},
      },
      "timestamp": "2025-08-16T10:00:00.000Z",
      "content": "Hello",
      "type": "text",
      "isRead": false,
    },
  ];

  final tMessageModels = tMessageJsonList
      .map((json) => MessageModel.fromJson(json))
      .toList();

  const chatId = '123';

  final tChatJsonList = [
    {
      "id": "123",
      "user1": {"id": "user1", "name": "Alice", "email": "alice@example.com"},
      "user2": {"id": "user2", "name": "Bob", "email": "bob@example.com"},
    },
    {
      "id": "124",
      "user1": {
        "id": "user3",
        "name": "Charlie",
        "email": "charlie@example.com",
      },
      "user2": {"id": "user4", "name": "Diana", "email": "diana@example.com"},
    },
  ];

  final tChatModels = tChatJsonList
      .map((json) => ChatModel.fromJson(json))
      .toList();

  group('DeleteChat Testing', () {
    test('should complete without error when response is 200', () async {
      // Arrange
      when(
        () => mockHttpClient.delete(
          Uri.parse('$baseUrl/chats/delete/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      // Act
      final call = remoteDataSourceImpl.deleteChat(chatId);

      // Assert
      expect(call, completes);
      verify(
        () => mockHttpClient.delete(
          Uri.parse('$baseUrl/chats/delete/$chatId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'token',
          },
        ),
      ).called(1);
    });

    test('should complete without error when response is 204', () async {
      when(
        () => mockHttpClient.delete(
          Uri.parse('$baseUrl/chats/delete/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 204));

      final call = remoteDataSourceImpl.deleteChat(chatId);

      expect(call, completes);
    });

    test('should throw NotFoundException when response is 404', () async {
      when(
        () => mockHttpClient.delete(
          Uri.parse('$baseUrl/chats/delete/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Not found', 404));

      expect(
        () => remoteDataSourceImpl.deleteChat(chatId),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('should throw ServerException for other status codes', () async {
      when(
        () => mockHttpClient.delete(
          Uri.parse('$baseUrl/chats/delete/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => remoteDataSourceImpl.deleteChat(chatId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getChatById Testing', () {
    test('should return ChatModel when response code is 200', () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/chats/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response(json.encode(tChatJson), 200));

      // act
      final result = await remoteDataSourceImpl.getChatById(chatId);

      // assert
      expect(result, equals(tChatModel));
      verify(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/chats/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });

    test('should throw NotFoundException when response code is 404', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/chats/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Not found', 404));

      expect(
        () => remoteDataSourceImpl.getChatById(chatId),
        throwsA(isA<NotFoundException>()),
      );
    });

    test(
      'should throw UnauthorizedException when response code is 401',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats/$chatId'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(
          () => remoteDataSourceImpl.getChatById(chatId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test(
      'should throw UnauthorizedException when response code is 403',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats/$chatId'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('Forbidden', 403));

        expect(
          () => remoteDataSourceImpl.getChatById(chatId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test('should throw ServerException for other response codes', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/chats/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => remoteDataSourceImpl.getChatById(chatId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getChatMessage Testing', () {
    test(
      'should return List<MessageModel> when response code is 200',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats/$chatId'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(tMessageJsonList), 200),
        );

        // act
        final result = await remoteDataSourceImpl.getChatMessage(chatId);

        // assert
        expect(result, equals(tMessageModels));
        verify(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats/$chatId'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      },
    );

    test('should throw NotFoundException when response code is 404', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/chats/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Not found', 404));

      expect(
        () => remoteDataSourceImpl.getChatMessage(chatId),
        throwsA(isA<NotFoundException>()),
      );
    });

    test(
      'should throw UnauthorizedException when response code is 401',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats/$chatId'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        expect(
          () => remoteDataSourceImpl.getChatMessage(chatId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test(
      'should throw UnauthorizedException when response code is 403',
      () async {
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats/$chatId'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('Forbidden', 403));

        expect(
          () => remoteDataSourceImpl.getChatMessage(chatId),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );

    test('should throw ServerException for other response codes', () async {
      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl/chats/$chatId'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => remoteDataSourceImpl.getChatMessage(chatId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getChats', () {
    test(
      'should return list of ChatModel when the response code is 200',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(tChatJsonList), 200),
        );

        // act
        final result = await remoteDataSourceImpl.getChats();

        // assert
        expect(result, equals(tChatModels));
        verify(
          () => mockHttpClient.get(
            Uri.parse('$baseUrl/chats'),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      },
    );

    test(
      'should throw UnauthorizedException when the response code is 401 or 403',
      () async {
        // arrange
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        // act
        final call = remoteDataSourceImpl.getChats;

        // assert
        expect(() => call(), throwsA(isA<UnauthorizedException>()));
      },
    );

    test('should throw ServerException for other response codes', () async {
      // arrange
      when(
        () => mockHttpClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('Error', 500));

      // act
      final call = remoteDataSourceImpl.getChats;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

  group('initiateChat', () {
    test('should return ChatModel when status code is 201', () async {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response(json.encode(tChatJson), 201));

      final result = await remoteDataSourceImpl.initiateChat('user2');

      expect(result, isA<ChatModel>());
      expect(result.id, '123');
      verify(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(1);
    });

    test(
      'should throw UnauthorizedException when status code is 401',
      () async {
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        expect(
          () => remoteDataSourceImpl.initiateChat('user2'),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );
  });

  group('sendMessage', () {
    final testMessage = tMessageModels.first;

    test('should send message through WebSocket sink', () async {
      await remoteDataSourceImpl.sendMessage(testMessage);

      final captured = verify(
        () => mockWebSocketSink.add(captureAny()),
      ).captured.single;
      final decoded = jsonDecode(captured);
      expect(decoded['id'], testMessage.id);
      expect(decoded['content'], testMessage.content);
    });
  });

  group('sendReadReceipt', () {
    test('should send read receipt through WebSocket sink', () async {
      const messageId = '1';
      const readerId = 'user1';

      await remoteDataSourceImpl.sendReadReceipt(
        messageId: messageId,
        readerId: readerId,
      );

      final captured = verify(
        () => mockWebSocketSink.add(captureAny()),
      ).captured.single;
      final decoded = jsonDecode(captured);
      expect(decoded['type'], 'read_receipt');
      expect(decoded['messageId'], messageId);
      expect(decoded['readerId'], readerId);
      expect(decoded.containsKey('timestamp'), true);
    });
  });

  group('receiveMessage', () {
    test('should convert WebSocket stream JSON to Message objects', () async {
      final controller = StreamController<String>();
      when(
        () => mockWebSocketChannel.stream,
      ).thenAnswer((_) => controller.stream);

      final stream = remoteDataSourceImpl.receiveMessage();
      final futureMessages = stream.take(1).toList();

      controller.add(jsonEncode(tMessageJsonList.first));

      final messages = await futureMessages;
      expect(messages.first.id, tMessageModels.first.id);
      expect(messages.first.content, tMessageModels.first.content);

      await controller.close();
    });
  });
}
