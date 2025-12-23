// import 'dart:async';

// import 'package:app_links/app_links.dart';
// import 'package:flutter/material.dart';

// import '../navigation/app_router.dart';
// import '../navigation/app_routes.dart';

// class DeepLinkService {
//   final _appLinks = AppLinks();
//   StreamSubscription? _linkSubscription;

//   DeepLinkService();

//   Future<void> initialize() async {
//     // Handle links when app is already open
//     _linkSubscription = _appLinks.uriLinkStream.listen(
//       (uri) {
//         debugPrint('Deep link received: $uri');
//         _handleDeepLink(uri);
//       },
//       onError: (err) {
//         debugPrint('Deep link error: $err');
//       },
//     );

//     // Handle link that opened the app
//     try {
//       final uri = await _appLinks.getInitialLink();
//       if (uri != null) {
//         debugPrint('Initial deep link: $uri');
//         // Delay to ensure app is ready
//         Future.delayed(const Duration(milliseconds: 500), () {
//           _handleDeepLink(uri);
//         });
//       }
//     } catch (e) {
//       debugPrint('Error getting initial deep link: $e');
//     }
//   }

//   void _handleDeepLink(Uri uri) {
//     // Parse deep link and navigate
//     final path = uri.path;
//     final queryParams = uri.queryParameters;

//     debugPrint('Deep link path: $path');
//     debugPrint('Deep link params: $queryParams');

//     // Handle different deep link patterns using GoRouter
//     if (path.startsWith('/product/')) {
//       final productId = path.split('/').last;
//       AppRouter.router.go(AppRoutes.productPath(productId));
//     } else if (path.startsWith('/profile/')) {
//       final userId = path.split('/').last;
//       AppRouter.router.go(AppRoutes.profilePath(userId));
//     } else if (path == '/home') {
//       AppRouter.router.go(AppRoutes.home);
//     } else if (path == '/settings') {
//       AppRouter.router.go(AppRoutes.settings);
//     } else {
//       debugPrint('Unknown deep link path: $path');
//       AppRouter.router.go(AppRoutes.home);
//     }
//   }

//   void dispose() {
//     _linkSubscription?.cancel();
//   }
// }
