import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/authentication/domain/entity/person.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login(String username, String password);
  Future<Either<Failure, void>> signup(Person person);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
}
