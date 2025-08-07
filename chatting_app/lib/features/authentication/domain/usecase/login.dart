import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class Login implements Usecase<void, Params> {
  final AuthRepository repository;

  Login(this.repository);
  @override
  Future<Either<Failure, void>> call(Params params) {
    // Implement the login logic here
    // For now, we return a placeholder response
    return repository.login(params.username, params.password);
  }
}

class Params {
  final String username;
  final String password;

  Params({required this.username, required this.password});
}
