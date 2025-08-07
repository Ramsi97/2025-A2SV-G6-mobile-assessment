import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class IsLoggedIn implements Usecase<bool, Params> {
  final AuthRepository repository;

  IsLoggedIn(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) {
    // Implement the logic to check if the user is logged in
    return repository.isLoggedIn();
  }
}

class Params {
  String token;

  Params({required this.token});
}
