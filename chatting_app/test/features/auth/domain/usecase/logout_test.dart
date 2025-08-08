import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:chatting_app/features/authentication/domain/usecase/logout.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPersonRepository extends Mock implements AuthRepository {}

void main() {
  late MockPersonRepository mockPersonRepository;
  late Logout logoutUseCase;

  setUp(() {
    mockPersonRepository = MockPersonRepository();
    logoutUseCase = Logout(mockPersonRepository);
  });

  test(
    'should call logout method of PersonRepository and return Right(null)',
    () async {
      // Arrange
      when(
        () => mockPersonRepository.logout(),
      ).thenAnswer((_) async => Right(null));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result, Right(null));
      verify(() => mockPersonRepository.logout()).called(1);
      verifyNoMoreInteractions(mockPersonRepository);
    },
  );
}
