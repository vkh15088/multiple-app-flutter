import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';
import '../../domain/usecases/get_{{feature_name.snakeCase()}}_usecase.dart';

part '{{feature_name.snakeCase()}}_event.dart';
part '{{feature_name.snakeCase()}}_state.dart';

class {{feature_name.pascalCase()}}Bloc extends Bloc<{{feature_name.pascalCase()}}Event, {{feature_name.pascalCase()}}State> {
  final Get{{feature_name.pascalCase()}}UseCase get{{feature_name.pascalCase()}}UseCase;

  {{feature_name.pascalCase()}}Bloc({
    required this.get{{feature_name.pascalCase()}}UseCase,
  }) : super({{feature_name.pascalCase()}}Initial()) {
    on<{{feature_name.pascalCase()}}LoadRequested>(_on{{feature_name.pascalCase()}}LoadRequested);
  }

  Future<void> _on{{feature_name.pascalCase()}}LoadRequested(
    {{feature_name.pascalCase()}}LoadRequested event,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    emit({{feature_name.pascalCase()}}Loading());

    final result = await get{{feature_name.pascalCase()}}UseCase({{feature_name.pascalCase()}}Params(id: event.id));

    result.fold(
      (failure) => emit({{feature_name.pascalCase()}}Error(message: failure.toString())),
      (entity) => emit({{feature_name.pascalCase()}}Loaded(entity: entity)),
    );
  }
}
