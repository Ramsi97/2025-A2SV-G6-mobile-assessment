import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/chatting_feature/data/datasource/chat_local_data_source.dart';
import 'package:chatting_app/features/chatting_feature/data/datasource/chat_remote_data_source.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting_feature/domain/entities/message.dart';
import 'package:chatting_app/features/chatting_feature/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> deleteChat(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteChat(chatId); // call remote deletion
        return const Right(null); // void result
      } on ServerException {
        return Left(ServerFailure('Failed to delete chat'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getChat() async {
    if (await networkInfo.isConnected) {
      try {
        final chats = await remoteDataSource.getChats();
        await localDataSource.cacheChats(chats); // optional: keep cache updated
        return Right(chats);
      } on ServerException {
        // Remote failed → try local fallback
        try {
          final cachedChats = await localDataSource.getChats();
          return Right(cachedChats);
        } on CacheException {
          return Left(
            ServerFailure(
              'Failed to fetch chats from server and no cache available',
            ),
          );
        }
      } catch (_) {
        return Left(ServerFailure('Unexpected server error'));
      }
    } else {
      try {
        final cachedChats = await localDataSource.getChats();
        return Right(cachedChats);
      } on CacheException {
        return Left(
          CacheFailure('No internet and failed to return cached chats'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final chat = await remoteDataSource.getChatById(chatId);
        await localDataSource.cacheChat(chat); // optional cache update
        return Right(chat);
      } on NotFoundException {
        return Left(NotFoundFailure('Chat with that ID not found'));
      } on ServerException {
        // Remote failed → try local
        try {
          final cachedChat = await localDataSource.getChatById(chatId);
          return Right(cachedChat);
        } on CacheException {
          return Left(ServerFailure('Server failed and no cached chat found'));
        }
      } catch (_) {
        return Left(ServerFailure('Unexpected server error'));
      }
    } else {
      try {
        final cachedChat = await localDataSource.getChatById(chatId);
        return Right(cachedChat);
      } on CacheException {
        return Left(CacheFailure('No internet and no cached chat found'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessage(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final messages = await remoteDataSource.getChatMessage(chatId);
        await localDataSource.cacheMessages(
          chatId,
          messages,
        ); // optional cache update
        return Right(messages);
      } on ServerException {
        // Remote failed → try cache
        try {
          final cachedMessages = await localDataSource.getChatMessage(chatId);
          return Right(cachedMessages);
        } on CacheException {
          return Left(
            ServerFailure('Server failed and no cached messages found'),
          );
        }
      } catch (_) {
        return Left(ServerFailure('Unexpected server error'));
      }
    } else {
      try {
        final cachedMessages = await localDataSource.getChatMessage(chatId);
        return Right(cachedMessages);
      } on CacheException {
        return Left(CacheFailure('No internet and no cached messages found'));
      }
    }
  }

  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final Chat chat = await remoteDataSource.initiateChat(userId);
        await localDataSource.cacheChat(chat);

        return Right(chat);
      } on ServerException {
        try {
          final Chat cachedChat = await localDataSource.getChatById(userId);
          return Right(cachedChat); // return cached chat
        } on CacheException {
          return Left(
            ServerFailure('Server failed and no cached chat available'),
          );
        } catch (_) {
          return Left(ServerFailure('Unexpected error'));
        }
      } catch (_) {
        return Left(ServerFailure('Unexpected error'));
      }
    } else {
      try {
        final Chat cachedChat = await localDataSource.getChatById(userId);
        return Right(cachedChat);
      } on CacheException {
        return Left(CacheFailure('No internet and no cached chat found'));
      } catch (_) {
        return Left(CacheFailure('Unexpected error'));
      }
    }
  }

  @override
  Future<Either<Failure, Stream<Message>>> receiveMessage() async {
    if (await networkInfo.isConnected) {
      try {
        final messageStream = remoteDataSource.receiveMessage();
        return Right(messageStream);
      } catch (_) {
        return Left(ServerFailure('Failed to receive messages'));
      }
    } else {
      return Left(CacheFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        await remoteDataSource.sendMessage(message);
        return Right(null);
      } on ServerException {
        try {
          await localDataSource.sendMessage(message);
          return Right(null);
        } on CacheException {
          return Left(
            CacheFailure('Failed to cache message after server failure'),
          );
        } catch (_) {
          return Left(CacheFailure('Unexpected error while caching message'));
        }
      } catch (_) {
        return Left(ServerFailure('Unexpected error while sending message'));
      }
    } else {
      try {
        await localDataSource.sendMessage(message);
        return Right(null);
      } on CacheException {
        return Left(CacheFailure('Unable to cache message offline'));
      } catch (_) {
        return Left(
          CacheFailure('Unexpected error while caching message offline'),
        );
      }
    }
  }
}
