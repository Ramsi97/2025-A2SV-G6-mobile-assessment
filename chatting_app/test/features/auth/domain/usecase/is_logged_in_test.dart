import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:chatting_app/features/authentication/domain/usecase/is_logged_in.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late IsLoggedIn isLoggedIn;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    isLoggedIn = IsLoggedIn(mockAuthRepository);
  });

  test('should return true when user is logged in', () async {
    // Arrange
    when(
      () => mockAuthRepository.isLoggedIn(),
    ).thenAnswer((_) async => Right(true));

    // Act
    final result = await isLoggedIn(NoParams());

    // Assert
    expect(result, Right(true));
    verify(() => mockAuthRepository.isLoggedIn()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return false when user is not logged in', () async {
    // Arrange
    when(
      () => mockAuthRepository.isLoggedIn(),
    ).thenAnswer((_) async => Right(false));

    // Act
    final result = await isLoggedIn(NoParams());

    // Assert
    expect(result, Right(false));
    verify(() => mockAuthRepository.isLoggedIn()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
