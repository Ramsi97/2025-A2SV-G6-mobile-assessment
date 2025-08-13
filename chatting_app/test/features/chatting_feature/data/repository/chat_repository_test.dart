

import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/chatting_feature/data/datasource/chat_local_data_source.dart';
import 'package:chatting_app/features/chatting_feature/data/datasource/chat_remote_data_source.dart';
import 'package:chatting_app/features/chatting_feature/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting_feature/data/repositories/chat_repository_impl.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:collection/collection.dart';


class MockChatLocalDataSource extends Mock implements ChatLocalDataSource{}
class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}

void main(){

  late MockChatLocalDataSource mockChatLocalDataSource;
  late MockChatRemoteDataSource mockChatRemoteDataSource;
  late MockNetworkInfo networkInfo;

  late ChatRepositoryImpl repositoryImpl;

  setUp((){
    mockChatRemoteDataSource = MockChatRemoteDataSource();
    mockChatLocalDataSource = MockChatLocalDataSource();
    networkInfo = MockNetworkInfo();
    
    repositoryImpl = ChatRepositoryImpl(localDataSource: mockChatLocalDataSource, remoteDataSource: mockChatRemoteDataSource, networkInfo: networkInfo);
  });

  final testUser1 = User(
    id: 'user1',
    name: 'Alice',
    email: 'alice@example.com',
  );

  final testUser2 = User(
    id: 'user2',
    name: 'Bob',
    email: 'bob@example.com',
  );

  ChatModel testChat = ChatModel(id: '1', user1: testUser1, user2: testUser2);

  final tChats = [
    ChatModel(id: '1', user1: testUser1, user2: testUser2),
    ChatModel(id: '2', user1: testUser1, user2: testUser2),
  ];

  final String chatId = '123';

  final testMessage = Message(id: '123', sender: testUser1, chat: testChat, timestamp: DateTime.now(), content: 'Hey', type: 'text');

  final eq = const DeepCollectionEquality();

  group('Delete chat Testing', () {
    const testChatId = 'chat1';

    test('should return Right(null) when deletion is successful', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.deleteChat(testChatId))
          .thenAnswer((_) async => Future.value()); // succeeds

      // act
      final result = await repositoryImpl.deleteChat(testChatId);

      // assert
      expect(result, const Right(null));
      verify(() => mockChatRemoteDataSource.deleteChat(testChatId)).called(1);
      verifyNoMoreInteractions(mockChatRemoteDataSource);
    });

    test('should return ServerFailure when server deletion fails', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.deleteChat(testChatId))
          .thenThrow(ServerException());

      // act
      final result = await repositoryImpl.deleteChat(testChatId);

      // assert
      expect(result, Left(ServerFailure('Failed to delete chat')));
      verify(() => mockChatRemoteDataSource.deleteChat(testChatId)).called(1);
      verifyNoMoreInteractions(mockChatRemoteDataSource);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repositoryImpl.deleteChat(testChatId);

      // assert
      expect(result, Left(NetworkFailure('No internet connection')));
      verifyZeroInteractions(mockChatRemoteDataSource);
    });
  });

  group('getChat Testing', () {

    test('should return remote chats when online and remote fetch succeeds', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChats()).thenAnswer((_) async => tChats);
      when(() => mockChatLocalDataSource.cacheChats(tChats)).thenAnswer((_) async => Future.value());

      // act
      final result = await repositoryImpl.getChat();

      // assert
      expect(result, Right(tChats));
      verify(() => mockChatRemoteDataSource.getChats()).called(1);
      verify(() => mockChatLocalDataSource.cacheChats(tChats)).called(1);
      verifyNoMoreInteractions(mockChatRemoteDataSource);
      verifyNoMoreInteractions(mockChatLocalDataSource);
    });

    test('should return cached chats when online but remote fetch fails', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChats()).thenThrow(ServerException());
      when(() => mockChatLocalDataSource.getChats()).thenAnswer((_) async => tChats);

      // act
      final result = await repositoryImpl.getChat();

      // assert
      expect(result, Right(tChats));
      verify(() => mockChatRemoteDataSource.getChats()).called(1);
      verify(() => mockChatLocalDataSource.getChats()).called(1);
    });

    test('should return ServerFailure when online and both remote and cache fail', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChats()).thenThrow(ServerException());
      when(() => mockChatLocalDataSource.getChats()).thenThrow(CacheException());

      // act
      final result = await repositoryImpl.getChat();

      // assert
      expect(result, Left(ServerFailure('Failed to fetch chats from server and no cache available')));
      verify(() => mockChatRemoteDataSource.getChats()).called(1);
      verify(() => mockChatLocalDataSource.getChats()).called(1);
    });

    test('should return cached chats when offline', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.getChats()).thenAnswer((_) async => tChats);

      // act
      final result = await repositoryImpl.getChat();

      // assert
      expect(result, Right(tChats));
      verify(() => mockChatLocalDataSource.getChats()).called(1);
      verifyZeroInteractions(mockChatRemoteDataSource);
    });

    test('should return CacheFailure when offline and cache fails', () async {
      // arrange
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.getChats()).thenThrow(CacheException());

      // act
      final result = await repositoryImpl.getChat();

      // assert
      expect(result, Left(CacheFailure('No internet and failed to return cached chats')));
      verify(() => mockChatLocalDataSource.getChats()).called(1);
      verifyZeroInteractions(mockChatRemoteDataSource);
    });
  });

  group('getChatById', () {
    test('returns chat from remote and caches it when connected', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChatById(chatId)).thenAnswer((_) async => testChat);
      when(() => mockChatLocalDataSource.cacheChat(testChat)).thenAnswer((_) async => Future.value());

      final result = await repositoryImpl.getChatById(chatId);

      expect(result, Right(testChat));
      verify(() => mockChatRemoteDataSource.getChatById(chatId)).called(1);
      verify(() => mockChatLocalDataSource.cacheChat(testChat)).called(1);
      verifyNever(() => mockChatLocalDataSource.getChatById(any()));
    });

    test('returns chat from cache when remote server fails', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChatById(chatId)).thenThrow(ServerException());
      when(() => mockChatLocalDataSource.getChatById(chatId)).thenAnswer((_) async => testChat);

      final result = await repositoryImpl.getChatById(chatId);

      expect(result, Right(testChat));
      verify(() => mockChatRemoteDataSource.getChatById(chatId)).called(1);
      verify(() => mockChatLocalDataSource.getChatById(chatId)).called(1);
    });

    test('returns NotFoundFailure if chat ID does not exist on remote', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChatById(chatId)).thenThrow(NotFoundException('Chat with that ID not found'));

      final result = await repositoryImpl.getChatById(chatId);

      expect(result, Left(NotFoundFailure('Chat with that ID not found')));
      verify(() => mockChatRemoteDataSource.getChatById(chatId)).called(1);
      verifyNever(() => mockChatLocalDataSource.getChatById(any()));
    });

    test('returns cached chat when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.getChatById(chatId)).thenAnswer((_) async => testChat);

      final result = await repositoryImpl.getChatById(chatId);

      expect(result, Right(testChat));
      verify(() => mockChatLocalDataSource.getChatById(chatId)).called(1);
      verifyNever(() => mockChatRemoteDataSource.getChatById(any()));
    });

    test('returns CacheFailure when offline and no cache exists', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.getChatById(chatId)).thenThrow(CacheException());

      final result = await repositoryImpl.getChatById(chatId);

      expect(result, Left(CacheFailure('No internet and no cached chat found')));
      verify(() => mockChatLocalDataSource.getChatById(chatId)).called(1);
      verifyNever(() => mockChatRemoteDataSource.getChatById(any()));
    });
  });

  group('getChatMessage', () {
    test('should return messages from remote when connected and cache them', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChatMessage(chatId))
          .thenAnswer((_) async => [testMessage]);
      when(() => mockChatLocalDataSource.cacheMessages(chatId, [testMessage]))
          .thenAnswer((_) async {});

      final result = await repositoryImpl.getChatMessage(chatId);

      expect(eq.equals(result, Right([testMessage])), true);
      verify(() => mockChatRemoteDataSource.getChatMessage(chatId)).called(1);
      verify(() => mockChatLocalDataSource.cacheMessages(chatId, [testMessage])).called(1);
    });

    test('should return cached messages when remote fails', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.getChatMessage(chatId)).thenThrow(ServerException());
      when(() => mockChatLocalDataSource.getChatMessage(chatId))
          .thenAnswer((_) async => [testMessage]);

      final result = await repositoryImpl.getChatMessage(chatId);

      expect(result, Right([testMessage]));
      verify(() => mockChatLocalDataSource.getChatMessage(chatId)).called(1);
    });

    test('should return CacheFailure when offline and no cache', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.getChatMessage(chatId)).thenThrow(CacheException());

      final result = await repositoryImpl.getChatMessage(chatId);

      expect(result, Left(CacheFailure('No internet and no cached messages found')));
      verify(() => mockChatLocalDataSource.getChatMessage(chatId)).called(1);
    });
  });

  group('initiateChat', () {
    test('should return chat from remote and cache it when connected', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.initiateChat('user2'))
          .thenAnswer((_) async => testChat);
      when(() => mockChatLocalDataSource.cacheChat(testChat))
          .thenAnswer((_) async {});

      final result = await repositoryImpl.initiateChat('user2');

      expect(result, Right(testChat));
      verify(() => mockChatRemoteDataSource.initiateChat('user2')).called(1);
      verify(() => mockChatLocalDataSource.cacheChat(testChat)).called(1);
    });

    test('should return cached chat if server fails', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.initiateChat('user2')).thenThrow(ServerException());
      when(() => mockChatLocalDataSource.getChatById('user2'))
          .thenAnswer((_) async => testChat);

      final result = await repositoryImpl.initiateChat('user2');

      expect(result, Right(testChat));
      verify(() => mockChatLocalDataSource.getChatById('user2')).called(1);
    });

    test('should return CacheFailure if offline and no cached chat', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.getChatById('user2')).thenThrow(CacheException());

      final result = await repositoryImpl.initiateChat('user2');

      expect(result, Left(CacheFailure('No internet and no cached chat found')));
      verify(() => mockChatLocalDataSource.getChatById('user2')).called(1);
    });
  });

  group('receiveMessage', () {
    test('should return stream from remote when connected', () async {
      final messageStream = Stream.fromIterable([testMessage]);
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.receiveMessage()).thenReturn(messageStream);

      final result = await repositoryImpl.receiveMessage();

      expect(result.isRight(), true);
      result.fold((_) {}, (stream) {
        expect(stream, messageStream);
      });
    });

    test('should return CacheFailure when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repositoryImpl.receiveMessage();

      expect(result, Left(CacheFailure('No internet connection')));
    });
  });

  group('sendMessage', () {
    test('should send message remotely when online', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.sendMessage(testMessage))
          .thenAnswer((_) async {});

      final result = await repositoryImpl.sendMessage(testMessage);

      expect(result, Right(null));
      verify(() => mockChatRemoteDataSource.sendMessage(testMessage)).called(1);
    });

    test('should cache message locally if remote fails', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockChatRemoteDataSource.sendMessage(testMessage))
          .thenThrow(ServerException());
      when(() => mockChatLocalDataSource.sendMessage(testMessage))
          .thenAnswer((_) async {});

      final result = await repositoryImpl.sendMessage(testMessage);

      expect(result, Right(null));
      verify(() => mockChatLocalDataSource.sendMessage(testMessage)).called(1);
    });

    test('should send message locally when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.sendMessage(testMessage))
          .thenAnswer((_) async {});

      final result = await repositoryImpl.sendMessage(testMessage);

      expect(result, Right(null));
      verify(() => mockChatLocalDataSource.sendMessage(testMessage)).called(1);
    });

    test('should return CacheFailure if offline and caching fails', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockChatLocalDataSource.sendMessage(testMessage))
          .thenThrow(CacheException());

      final result = await repositoryImpl.sendMessage(testMessage);

      expect(result, Left(CacheFailure('Unable to cache message offline')));
    });
  });

}