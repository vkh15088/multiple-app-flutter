import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
// import '../services/airbridge_service.dart';
// import '../services/deep_link_service.dart';
import '../remote_config/bloc/remote_config_bloc.dart';
import '../services/notification_service.dart';
import '../services/remote_config_service.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register Navigator Key
  getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

  // Register SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Register Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  getIt.registerLazySingleton<FirebaseCrashlytics>(() => FirebaseCrashlytics.instance);
  getIt.registerLazySingleton<FirebasePerformance>(() => FirebasePerformance.instance);
  getIt.registerLazySingleton<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance);

  // Register Services
  getIt.registerLazySingleton<NotificationService>(() => NotificationService(getIt(), getIt()));
  getIt.registerLazySingleton<RemoteConfigService>(() => RemoteConfigService(getIt()));
  // getIt.registerLazySingleton<DeepLinkService>(
  //   () => DeepLinkService(),
  // );
  // getIt.registerLazySingleton<AirbridgeService>(
  //   () => AirbridgeService(),
  // );

  // Register Remote Config BLoC
  getIt.registerFactory(() => RemoteConfigBloc(remoteConfigService: getIt()));

  // Register Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt()));
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      signUpUseCase: getIt(),
      logoutUseCase: getIt(),
      checkAuthStatusUseCase: getIt(),
    ),
  );
}
