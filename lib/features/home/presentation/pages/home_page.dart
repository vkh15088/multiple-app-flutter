import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/remote_config/bloc/remote_config_bloc.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localNotificationService = getIt<LocalNotificationService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<RemoteConfigBloc>().add(RemoteConfigRefreshRequested());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
              child: Center(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is AuthAuthenticated) {
                      return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                        builder: (context, remoteConfigState) {
                          final welcomeMessage = remoteConfigState is RemoteConfigLoaded
                              ? remoteConfigState.welcomeMessage
                              : '';

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
                              const SizedBox(height: 24),
                              Text('Welcome!', style: Theme.of(context).textTheme.headlineMedium),
                              const SizedBox(height: 8),
                              if (welcomeMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    welcomeMessage,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              if (remoteConfigState is RemoteConfigLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(authState.user.email, style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 32),
                              Card(
                                margin: const EdgeInsets.all(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Firebase Services Active:',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(height: 12),
                                      const Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Authentication'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Cloud Messaging'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Crashlytics'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Performance Monitoring'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Remote Config'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Local Notifications'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const SizedBox(height: 16),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Test Local Notifications:',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () => localNotificationService.showWelcomeNotification(),
                                            icon: const Icon(Icons.waving_hand, size: 16),
                                            label: const Text('Welcome'),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () => localNotificationService.showPromotionNotification(),
                                            icon: const Icon(Icons.local_offer, size: 16),
                                            label: const Text('Promotion'),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                localNotificationService.showFeatureNotification('Dark Mode'),
                                            icon: const Icon(Icons.lightbulb, size: 16),
                                            label: const Text('Feature'),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              final scheduledDate = DateTime.now().add(const Duration(seconds: 5));
                                              localNotificationService.scheduleReminderNotification(
                                                message: 'This is your scheduled reminder!',
                                                scheduledDate: scheduledDate,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Notification scheduled for 5 seconds')),
                                              );
                                            },
                                            icon: const Icon(Icons.schedule, size: 16),
                                            label: const Text('Schedule'),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
