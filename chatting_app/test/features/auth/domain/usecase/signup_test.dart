import 'package:chatting_app/features/authentication/domain/entity/person.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:chatting_app/features/authentication/domain/usecase/signup.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPersonRepository extends Mock implements AuthRepository {}

void main() {
  late MockPersonRepository mockPersonRepository;
  late Signup signupUseCase;

  setUp(() {
    mockPersonRepository = MockPersonRepository();
    signupUseCase = Signup(mockPersonRepository);
  });

  test(
    'should call login method of PersonRepository and return Right(null)',
    () async {
      // Arrange
      final Person tPerson = Person(
        name: 'name',
        email: 'username@gmail.com',
        password: 'password',
      );

      when(
        () => mockPersonRepository.signup(tPerson),
      ).thenAnswer((_) async => Right(null));

      // Act
      final result = await signupUseCase(tPerson);

      // Assert
      expect(result, Right(null));
      verify(() => mockPersonRepository.signup(tPerson)).called(1);
      verifyNoMoreInteractions(mockPersonRepository);
    },
  );
}
