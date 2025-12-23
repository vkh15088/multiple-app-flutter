import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hung_multiple_app/core/config/firebase_options.dart';
import 'package:hung_multiple_app/core/di/injection.dart';
import 'package:hung_multiple_app/core/navigation/app_router.dart';
import 'package:hung_multiple_app/core/services/notification_service.dart';
import 'package:hung_multiple_app/core/services/remote_config_service.dart';
import 'package:hung_multiple_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workmanager/workmanager.dart';

import 'core/remote_config/bloc/remote_config_bloc.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/timezone_service.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}

// Background task handler
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    debugPrint('Background task: $task');
    // Handle background tasks
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase.initializeApp failed: $e');
  }

  // Setup Crashlytics
  FlutterError.onError = (errorDetails) {
    //Framework (UI)
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    //Platform (Native)
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Setup Firebase Performance
  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  // Setup FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Workmanager
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

  // Setup dependency injection
  await configureDependencies();

  // Initialize services
  await getIt<TimezoneService>().initialize();
  await getIt<LocalNotificationService>().initialize();
  await getIt<NotificationService>().initialize();
  await getIt<RemoteConfigService>().initialize();
  // await getIt<DeepLinkService>().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => getIt<RemoteConfigBloc>()..add(RemoteConfigFetchRequested())),
      ],
      child: MaterialApp.router(
        title: 'Firebase Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
