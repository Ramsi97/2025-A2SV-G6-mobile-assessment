import 'package:bloc_test/bloc_test.dart';
import 'package:chatting_app/core/error/failure.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:chatting_app/features/authentication/domain/entity/person.dart';
import 'package:chatting_app/features/authentication/domain/usecase/is_logged_in.dart';
import 'package:chatting_app/features/authentication/domain/usecase/login.dart';
import 'package:chatting_app/features/authentication/domain/usecase/logout.dart';
import 'package:chatting_app/features/authentication/domain/usecase/signup.dart';
import 'package:chatting_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements Login {}

class MockLogoutUsecase extends Mock implements Logout {}

class MockSignupUsecase extends Mock implements Signup {}

class MockIsLoggedInUsecase extends Mock implements IsLoggedIn {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockSignupUsecase mockSignupUsecase;
  late MockIsLoggedInUsecase mockIsLoggedInUsecase;
  late AuthBloc bloc;

  setUpAll(() {
    registerFallbackValue(Params(email: '', password: ''));
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockSignupUsecase = MockSignupUsecase();
    mockIsLoggedInUsecase = MockIsLoggedInUsecase();

    bloc = AuthBloc(
      login: mockLoginUsecase,
      logout: mockLogoutUsecase,
      signup: mockSignupUsecase,
      isLoggedIn: mockIsLoggedInUsecase,
    );
  });

  blocTest<AuthBloc, AuthState>(
    'emits [Authenticated] when user is logged in and token is retrieved',
    build: () {
      when(
        () => mockIsLoggedInUsecase(NoParams()),
      ).thenAnswer((_) async => Right(true));
      return bloc;
    },
    act: (bloc) => bloc.add(AuthCheckedRequested()),
    expect: () => [Authenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Unauthenticated] when user is not logged in',
    build: () {
      when(
        () => mockIsLoggedInUsecase(NoParams()),
      ).thenAnswer((_) async => Right(false));
      return bloc;
    },
    act: (bloc) => bloc.add(AuthCheckedRequested()),
    expect: () => [Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Authenticated] when user logs in successfully',
    build: () {
      when(() => mockLoginUsecase(any())).thenAnswer((_) async => Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(LoginRequested('email', 'password')),
    expect: () => [AuthLoading(), Authenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Unauthenticated] when user logs out successfully',
    build: () {
      when(() => mockLogoutUsecase()).thenAnswer((_) async => Right(null));
      return bloc;
    },
    act: (bloc) => bloc.add(LoggedOut()),
    expect: () => [AuthLoading(), Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [Authenticated] when user signs up successfully',
    build: () {
      when(
        () => mockSignupUsecase(
          Person(name: 'name', email: 'email', password: 'password'),
        ),
      ).thenAnswer((_) async => Right(null));

      return bloc;
    },
    act: (bloc) => bloc.add(SignUpRequested('name', 'password', 'email')),
    expect: () => [AuthLoading(), Unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthError] when login fails',
    build: () {
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure, Login failed')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(LoginRequested('email', 'password')),
    expect: () => [AuthLoading(), AuthError('Login failed')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthError] when sign up fails',
    build: () {
      when(
        () => mockSignupUsecase(
          Person(name: 'name', email: 'email', password: 'password'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure('Sign up failed')));
      return bloc;
    },
    act: (bloc) => bloc.add(SignUpRequested('name', 'password', 'email')),
    expect: () => [AuthLoading(), AuthError('Sign up failed')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthError] when checking login status fails',
    build: () {
      when(() => mockIsLoggedInUsecase(NoParams())).thenAnswer(
        (_) async => Left(CacheFailure('Check login status failed')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(AuthCheckedRequested()),
    expect: () => [AuthError('Failed to check login status')],
  );
}
