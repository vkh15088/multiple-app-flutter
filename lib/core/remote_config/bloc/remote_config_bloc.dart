import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/remote_config_service.dart';

part 'remote_config_event.dart';
part 'remote_config_state.dart';

class RemoteConfigBloc extends Bloc<RemoteConfigEvent, RemoteConfigState> {
  final RemoteConfigService remoteConfigService;

  RemoteConfigBloc({required this.remoteConfigService}) : super(RemoteConfigInitial()) {
    on<RemoteConfigFetchRequested>(_onFetchRequested);
    on<RemoteConfigRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onFetchRequested(RemoteConfigFetchRequested event, Emitter<RemoteConfigState> emit) async {
    emit(RemoteConfigLoading());

    try {
      // Fetch and activate remote config
      await remoteConfigService.fetchAndActivate();

      // Get all config values
      final welcomeMessage = remoteConfigService.getWelcomeMessage();
      final maintenanceMode = remoteConfigService.isMaintenanceMode();
      final apiBaseUrl = remoteConfigService.getApiBaseUrl();

      emit(
        RemoteConfigLoaded(welcomeMessage: welcomeMessage, maintenanceMode: maintenanceMode, apiBaseUrl: apiBaseUrl),
      );
    } catch (e) {
      emit(RemoteConfigError(message: e.toString()));
    }
  }

  Future<void> _onRefreshRequested(RemoteConfigRefreshRequested event, Emitter<RemoteConfigState> emit) async {
    // Keep the current state while refreshing
    if (state is RemoteConfigLoaded) {
      emit((state as RemoteConfigLoaded).copyWith(isRefreshing: true));
    } else {
      emit(RemoteConfigLoading());
    }

    try {
      await remoteConfigService.fetchAndActivate();

      final welcomeMessage = remoteConfigService.getWelcomeMessage();
      final maintenanceMode = remoteConfigService.isMaintenanceMode();
      final apiBaseUrl = remoteConfigService.getApiBaseUrl();

      emit(
        RemoteConfigLoaded(
          welcomeMessage: welcomeMessage,
          maintenanceMode: maintenanceMode,
          apiBaseUrl: apiBaseUrl,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      emit(RemoteConfigError(message: e.toString()));
    }
  }
}
