import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/domain/entity/person.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class Signup implements Usecase<void, Person> {
  final AuthRepository personRepository;

  Signup(this.personRepository);

  @override
  Future<Either<Failure, void>> call(Person person) {
    return personRepository.signup(person);
  }
}
