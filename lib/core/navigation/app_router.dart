import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../di/injection.dart';
import 'app_routes.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,

    // Redirect logic based on auth state
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final isGoingToSignUp = state.matchedLocation == AppRoutes.signup;

      // If not authenticated and not going to login/signup, redirect to login
      if (!isAuthenticated && !isGoingToLogin && !isGoingToSignUp) {
        return AppRoutes.login;
      }

      // If authenticated and going to login/signup, redirect to home
      if (isAuthenticated && (isGoingToLogin || isGoingToSignUp)) {
        return AppRoutes.home;
      }

      // No redirect needed
      return null;
    },

    // Listen to auth state changes
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),

    routes: [
      GoRoute(path: AppRoutes.login, name: AppRoutes.loginName, builder: (context, state) => const LoginPage()),

      GoRoute(path: AppRoutes.signup, name: AppRoutes.signupName, builder: (context, state) => const SignUpPage()),

      GoRoute(path: AppRoutes.home, name: AppRoutes.homeName, builder: (context, state) => const HomePage()),

      GoRoute(
        path: AppRoutes.product,
        name: AppRoutes.productName,
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? 'unknown';
          final extra = state.extra as Map<String, dynamic>?;

          return ProductPage(productId: productId, notificationData: extra);
        },
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (context, state) {
          final userId = state.pathParameters['id'] ?? '';
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: Center(child: Text('User ID: $userId')),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: const Center(child: Text('Settings Page')),
        ),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => context.go(AppRoutes.home), child: const Text('Go Home')),
          ],
        ),
      ),
    ),
  );
}

// Helper class to refresh GoRouter when stream emits
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
