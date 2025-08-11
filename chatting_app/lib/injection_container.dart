import 'package:chatting_app/core/network/network_info.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:chatting_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:chatting_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:chatting_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:chatting_app/features/authentication/domain/usecase/is_logged_in.dart';
import 'package:chatting_app/features/authentication/domain/usecase/login.dart';
import 'package:chatting_app/features/authentication/domain/usecase/logout.dart';
import 'package:chatting_app/features/authentication/domain/usecase/signup.dart';
import 'package:chatting_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Features
  sl.registerFactory(
    () => AuthBloc(login: sl(), logout: sl(), signup: sl(), isLoggedIn: sl()),
  );

  //usecases

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => IsLoggedIn(sl()));

  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authLocalDataSource: sl(),
      authRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External dependencies

  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
}
