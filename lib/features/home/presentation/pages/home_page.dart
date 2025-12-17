import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/remote_config/bloc/remote_config_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                              const Card(
                                margin: EdgeInsets.all(16),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Firebase Services Active:',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Authentication'),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Cloud Messaging'),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Crashlytics'),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Performance Monitoring'),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Remote Config'),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.check, color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Text('Airbridge SDK'),
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
