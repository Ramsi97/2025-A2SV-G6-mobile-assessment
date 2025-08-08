import 'package:chatting_app/core/error/exceptions.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:chatting_app/features/authentication/data/model/person_model.dart';
import 'package:chatting_app/features/authentication/domain/entity/person.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.authLocalDataSource,
    required this.authRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> login(String username, String password) async {
    // Implement the login logic here
    // For now, we return a placeholder response
    if (await networkInfo.isConnected) {
      try {
        final token = await authRemoteDataSource.login(username, password);
        await authLocalDataSource.cachetoken(token);
        return Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signup(Person person) async {
    if (await networkInfo.isConnected) {
      try {
        final personModel = PersonModel(
          name: person.name,
          email: person.email,
          password: person.password,
        );
        return authRemoteDataSource.signup(personModel).then((_) {
          return Right(null);
        });
      } on ServerException {
        return Future.value(Left(ServerFailure()));
      }
    } else {
      return Future.value(Left(NetworkFailure()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authLocalDataSource.logout();
      return Future.value(Right(null));
    } on CacheException {
      return Future.value(Left(CacheFailure()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await authLocalDataSource.isLoggedIn();
      return Right(token);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
