import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class Logout {
  final AuthRepository personRepository;

  Logout(this.personRepository);

  Future<Either<Failure, void>> call() {
    return personRepository.logout();
  }
}
