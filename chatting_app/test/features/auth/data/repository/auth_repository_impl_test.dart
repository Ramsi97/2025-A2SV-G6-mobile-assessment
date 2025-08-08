import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:chatting_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    authRepositoryImpl = AuthRepositoryImpl(
      authLocalDataSource: mockAuthLocalDataSource,
      authRemoteDataSource: mockAuthRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('login Testing', () {
    test('should return Right(null) when login is successful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockAuthRemoteDataSource.login(any(), any()),
      ).thenAnswer((_) async => 'token');

      when(
        () => mockAuthLocalDataSource.cachetoken('token'),
      ).thenAnswer((_) async {});

      final result = await authRepositoryImpl.login('email', 'password');

      expect(result, Right(null));
      verify(
        () => mockAuthRemoteDataSource.login('email', 'password'),
      ).called(1);
      verify(() => mockAuthLocalDataSource.cachetoken('token')).called(1);
    });

    test(
      'should return Left(NetworkFailure) when there is no network',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final result = await authRepositoryImpl.login('email', 'password');

        expect(result, isA<Left>());
        verifyNever(() => mockAuthRemoteDataSource.login(any(), any()));
      },
    );
  });

  group('isLoggedIn Testing', () {
    test('should return true when user is logged in', () async {
      when(
        () => mockAuthLocalDataSource.isLoggedIn(),
      ).thenAnswer((_) async => true);

      final result = await authRepositoryImpl.isLoggedIn();

      expect(result, Right(true));
      verify(() => mockAuthLocalDataSource.isLoggedIn()).called(1);
    });

    test('should return false when user is not logged in', () async {
      when(
        () => mockAuthLocalDataSource.isLoggedIn(),
      ).thenAnswer((_) async => false);

      final result = await authRepositoryImpl.isLoggedIn();

      expect(result, Right(false));
      verify(() => mockAuthLocalDataSource.isLoggedIn()).called(1);
    });
  });
}
