import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/chatting/data/datasources/chatting_local_data_source.dart';
import 'package:chatting_app/features/chatting/data/datasources/chatting_remote_data_source.dart';
import 'package:chatting_app/features/chatting/domain/entities/chat.dart';
import 'package:chatting_app/features/chatting/domain/entities/message.dart';
import 'package:chatting_app/features/chatting/domain/repositories/chatting_repository.dart';
import 'package:dartz/dartz.dart';

class ChattingRepositoryImpl implements ChattingRepository {
  final ChattingRemoteDataSource remoteDataSource;
  final ChattingLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChattingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> deleteChat(String id) async {
    try {
      await remoteDataSource.deleteChat(id);
      await localDataSource.deleteCachedChat(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Chat>>> getChats(String userId) async {
    try {
      final remoteChats = await remoteDataSource.getChats(userId);
      await localDataSource.cacheChats(remoteChats);
      return Right(remoteChats);
    } on ServerException {
      try {
        final localChats = await localDataSource.getCachedChats(userId);
        return Right(localChats);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    try {
      final remoteChat = await remoteDataSource.getChatById(chatId);
      await localDataSource.cacheChat(remoteChat);
      return Right(remoteChat);
    } on ServerException {
      try {
        final localChat = await localDataSource.getCachedChatById(chatId);
        return Right(localChat);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Chat>> initChat(String userId) async {
    try {
      final remoteChat = await remoteDataSource.initChat(userId);
      await localDataSource.cacheChat(remoteChat);
      return Right(remoteChat);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessage(String chatId) async {
    try {
      final remoteMessages = await remoteDataSource.getMessages(chatId);
      await localDataSource.cacheMessages(chatId, remoteMessages);
      return Right(remoteMessages);
    } on ServerException {
      try {
        final localMessages = await localDataSource.getCachedMessages(chatId);
        return Right(localMessages);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    String chatId,
    Message message,
  ) async {
    try {
      await remoteDataSource.sendMessage(chatId, message as dynamic);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Message> receiveMessage(String chatId) {
    return remoteDataSource.receiveMessage(chatId);
  }
}
