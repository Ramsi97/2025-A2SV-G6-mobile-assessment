import 'package:bloc/bloc.dart';
import 'package:chatting_app/core/usecase/usecase.dart';
import 'package:chatting_app/features/authentication/domain/entity/person.dart';
import 'package:chatting_app/features/authentication/domain/usecase/is_logged_in.dart';
import 'package:chatting_app/features/authentication/domain/usecase/login.dart';
import 'package:chatting_app/features/authentication/domain/usecase/logout.dart';
import 'package:chatting_app/features/authentication/domain/usecase/signup.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Logout logoutUsecase;
  final Signup signupUsecase;
  final IsLoggedIn isLogedInUsecase;

  static const cachedTokenKey = 'token';

  AuthBloc({
    required Login login,
    required Logout logout,
    required Signup signup,
    required IsLoggedIn isLoggedIn,
  }) : loginUsecase = login,
       logoutUsecase = logout,
       signupUsecase = signup,
       isLogedInUsecase = isLoggedIn,
       super(AuthInitial()) {
    // ✅ Each event is registered independently and at the top level

    on<AuthCheckedRequested>((event, emit) async {
      final isLoggedIn = await isLogedInUsecase(NoParams());
      await isLoggedIn.fold(
        (failure) async => emit(AuthError('Failed to check login status')),
        (isLoggedIn) async {
          if (isLoggedIn) {
            emit(Authenticated());
          } else {
            emit(Unauthenticated());
          }
        },
      );
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthLoading());
      emit(Authenticated());
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthLoading());
      await logoutUsecase();
      emit(Unauthenticated());
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signupUsecase(
        Person(name: event.name, email: event.email, password: event.password),
      );
      await result.fold(
        (failure) async {
          emit(AuthError('Sign up failed'));
        },
        (_) async {
          emit(Unauthenticated());
        },
      );
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUsecase(
        Params(email: event.email, password: event.password),
      );
      await result.fold(
        (failure) async {
          emit(AuthError('Login failed'));
        },
        (_) async {
          emit(Authenticated());
        },
      );
    });
  }
}
