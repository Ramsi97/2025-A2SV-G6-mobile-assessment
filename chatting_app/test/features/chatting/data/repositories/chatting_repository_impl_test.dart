import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/chatting/data/datasources/chatting_local_data_source.dart';
import 'package:chatting_app/features/chatting/data/datasources/chatting_remote_data_source.dart';
import 'package:chatting_app/features/chatting/data/model/chat_model.dart';
import 'package:chatting_app/features/chatting/data/model/message_model.dart';
import 'package:chatting_app/features/chatting/data/model/user_model.dart';
import 'package:chatting_app/features/chatting/data/repositories/chatting_repository_impl.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockRemoteDataSource extends Mock implements ChattingRemoteDataSource {}

class ChatModelFake extends Fake implements ChatModel {}

class MockLocalDataSource extends Mock implements ChattingLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late ChattingRepositoryImpl repository;
  late MockNetworkInfo networkInfo;

  setUpAll(() {
    registerFallbackValue(ChatModelFake());
  });

  // Fake user models
  final userModel1 = UserModel(
    id: 'u1',
    name: 'John Doe',
    email: 'john@example.com',
  );
  final userModel2 = UserModel(
    id: 'u2',
    name: 'Jane Smith',
    email: 'jane@example.com',
  );

  final chatModel = ChatModel(id: 'c1', user1: userModel1, user2: userModel2);

  final messageModel = MessageModel(
    id: 'm1',
    sender: userModel1,
    chat: chatModel,
    content: 'Hello there',
    type: 'text',
  );

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();

    repository = ChattingRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: networkInfo,
    );
  });

  group('deleteChat', () {
    const chatId = 'c1';

    test('should delete chat remotely and locally when successful', () async {
      when(
        () => mockRemoteDataSource.deleteChat(chatId),
      ).thenAnswer((_) async => Future.value());
      when(
        () => mockLocalDataSource.deleteCachedChat(chatId),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.deleteChat(chatId);

      expect(result, Right(null));
      verify(() => mockRemoteDataSource.deleteChat(chatId)).called(1);
      verify(() => mockLocalDataSource.deleteCachedChat(chatId)).called(1);
    });

    test('should return ServerFailure when remote delete throws', () async {
      when(
        () => mockRemoteDataSource.deleteChat(chatId),
      ).thenThrow(ServerException());

      final result = await repository.deleteChat(chatId);

      expect(result.isLeft(), true);
      verify(() => mockRemoteDataSource.deleteChat(chatId)).called(1);
      verifyNever(() => mockLocalDataSource.deleteCachedChat(chatId));
    });
  });

  group('getChats', () {
    const userId = 'u1';
    final chatModelList = [chatModel];
    final chatList = chatModelList.map((e) => e as Chat).toList();

    test('should get chats remotely and cache them locally', () async {
      when(
        () => mockRemoteDataSource.getChats(userId),
      ).thenAnswer((_) async => chatModelList);
      when(
        () => mockLocalDataSource.cacheChats(chatModelList),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getChats(userId);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), chatList);
      verify(() => mockRemoteDataSource.getChats(userId)).called(1);
      verify(() => mockLocalDataSource.cacheChats(chatModelList)).called(1);
    });

    test('should return cached chats when remote call fails', () async {
      when(
        () => mockRemoteDataSource.getChats(userId),
      ).thenThrow(ServerException());
      when(
        () => mockLocalDataSource.getCachedChats(userId),
      ).thenAnswer((_) async => chatModelList);

      final result = await repository.getChats(userId);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), chatList);
      verify(() => mockRemoteDataSource.getChats(userId)).called(1);
      verify(() => mockLocalDataSource.getCachedChats(userId)).called(1);
    });

    test('should return CacheFailure when no cached chats available', () async {
      when(
        () => mockRemoteDataSource.getChats(userId),
      ).thenThrow(ServerException());
      when(
        () => mockLocalDataSource.getCachedChats(userId),
      ).thenThrow(CacheException());

      final result = await repository.getChats(userId);

      expect(result.isLeft(), true);
      verify(() => mockRemoteDataSource.getChats(userId)).called(1);
      verify(() => mockLocalDataSource.getCachedChats(userId)).called(1);
    });
  });

  group('getChatById', () {
    const chatId = 'c1';

    test('should get chat remotely and cache it locally', () async {
      when(
        () => mockRemoteDataSource.getChatById(chatId),
      ).thenAnswer((_) async => chatModel);
      when(
        () => mockLocalDataSource.cacheChat(chatModel),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getChatById(chatId);

      expect(result, Right(chatModel));
      verify(() => mockRemoteDataSource.getChatById(chatId)).called(1);
      verify(() => mockLocalDataSource.cacheChat(chatModel)).called(1);
    });

    test('should return cached chat when remote call fails', () async {
      when(
        () => mockRemoteDataSource.getChatById(chatId),
      ).thenThrow(ServerException());
      when(
        () => mockLocalDataSource.getCachedChatById(chatId),
      ).thenAnswer((_) async => chatModel);

      final result = await repository.getChatById(chatId);

      expect(result, Right(chatModel));
      verify(() => mockRemoteDataSource.getChatById(chatId)).called(1);
      verify(() => mockLocalDataSource.getCachedChatById(chatId)).called(1);
    });

    test('should return CacheFailure when no cached chat available', () async {
      when(
        () => mockRemoteDataSource.getChatById(chatId),
      ).thenThrow(ServerException());
      when(
        () => mockLocalDataSource.getCachedChatById(chatId),
      ).thenThrow(CacheException());

      final result = await repository.getChatById(chatId);

      expect(result.isLeft(), true);
      verify(() => mockRemoteDataSource.getChatById(chatId)).called(1);
      verify(() => mockLocalDataSource.getCachedChatById(chatId)).called(1);
    });
  });

  group('initChat', () {
    const userId = 'u1';

    test('should initiate chat remotely and cache it locally', () async {
      when(
        () => mockRemoteDataSource.initChat(userId),
      ).thenAnswer((_) async => chatModel);
      when(
        () => mockLocalDataSource.cacheChat(chatModel),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.initChat(userId);

      expect(result, Right(chatModel));
      verify(() => mockRemoteDataSource.initChat(userId)).called(1);
      verify(() => mockLocalDataSource.cacheChat(chatModel)).called(1);
    });

    test('should return ServerFailure when remote init fails', () async {
      when(
        () => mockRemoteDataSource.initChat(userId),
      ).thenThrow(ServerException());

      final result = await repository.initChat(userId);

      expect(result, Left(ServerFailure()));
      verify(() => mockRemoteDataSource.initChat(userId)).called(1);
      verifyNever(() => mockLocalDataSource.cacheChat(any()));
    });
  });

  group('getMessage', () {
    const chatId = 'c1';
    final messageModelList = [messageModel];
    final messageList = messageModelList.map((e) => e as Message).toList();

    test('should get messages remotely and cache them locally', () async {
      when(
        () => mockRemoteDataSource.getMessages(chatId),
      ).thenAnswer((_) async => messageModelList);
      when(
        () => mockLocalDataSource.cacheMessages(chatId, messageModelList),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.getMessage(chatId);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), messageList);
      verify(() => mockRemoteDataSource.getMessages(chatId)).called(1);
      verify(
        () => mockLocalDataSource.cacheMessages(chatId, messageModelList),
      ).called(1);
    });

    test('should return cached messages when remote call fails', () async {
      when(
        () => mockRemoteDataSource.getMessages(chatId),
      ).thenThrow(ServerException());
      when(
        () => mockLocalDataSource.getCachedMessages(chatId),
      ).thenAnswer((_) async => messageModelList);

      final result = await repository.getMessage(chatId);

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), messageList);
      verify(() => mockRemoteDataSource.getMessages(chatId)).called(1);
      verify(() => mockLocalDataSource.getCachedMessages(chatId)).called(1);
    });

    test(
      'should return CacheFailure when no cached messages available',
      () async {
        when(
          () => mockRemoteDataSource.getMessages(chatId),
        ).thenThrow(ServerException());
        when(
          () => mockLocalDataSource.getCachedMessages(chatId),
        ).thenThrow(CacheException());

        final result = await repository.getMessage(chatId);

        expect(result.isLeft(), true);
        verify(() => mockRemoteDataSource.getMessages(chatId)).called(1);
        verify(() => mockLocalDataSource.getCachedMessages(chatId)).called(1);
      },
    );
  });
}
