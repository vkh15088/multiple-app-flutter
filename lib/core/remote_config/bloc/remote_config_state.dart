part of 'remote_config_bloc.dart';

abstract class RemoteConfigState extends Equatable {
  const RemoteConfigState();

  @override
  List<Object?> get props => [];
}

class RemoteConfigInitial extends RemoteConfigState {}

class RemoteConfigLoading extends RemoteConfigState {}

class RemoteConfigLoaded extends RemoteConfigState {
  final String welcomeMessage;
  final bool maintenanceMode;
  final String apiBaseUrl;
  final bool isRefreshing;

  const RemoteConfigLoaded({
    required this.welcomeMessage,
    required this.maintenanceMode,
    required this.apiBaseUrl,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [welcomeMessage, maintenanceMode, apiBaseUrl, isRefreshing];

  RemoteConfigLoaded copyWith({String? welcomeMessage, bool? maintenanceMode, String? apiBaseUrl, bool? isRefreshing}) {
    return RemoteConfigLoaded(
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class RemoteConfigError extends RemoteConfigState {
  final String message;

  const RemoteConfigError({required this.message});

  @override
  List<Object?> get props => [message];
}
