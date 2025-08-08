import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class Login implements Usecase<void, Params> {
  final AuthRepository repository;

  Login(this.repository);
  @override
  Future<Either<Failure, void>> call(Params params) {
    return repository.login(params.email, params.password);
  }
}

class Params {
  final String email;
  final String password;

  Params({required this.email, required this.password});
}
