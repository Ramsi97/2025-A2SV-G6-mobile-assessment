import 'package:bloc/bloc.dart';
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
    on<AuthEvent>((event, emit) {
      // Basic event handler: emit initial state for any event
      emit(AuthInitial());
    });
  }
}
