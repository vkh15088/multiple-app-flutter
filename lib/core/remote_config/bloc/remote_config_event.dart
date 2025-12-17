part of 'remote_config_bloc.dart';

abstract class RemoteConfigEvent extends Equatable {
  const RemoteConfigEvent();

  @override
  List<Object?> get props => [];
}

class RemoteConfigFetchRequested extends RemoteConfigEvent {}

class RemoteConfigRefreshRequested extends RemoteConfigEvent {}
