part of '{{feature_name.snakeCase()}}_bloc.dart';

abstract class {{feature_name.pascalCase()}}State extends Equatable {
  const {{feature_name.pascalCase()}}State();

  @override
  List<Object?> get props => [];
}

class {{feature_name.pascalCase()}}Initial extends {{feature_name.pascalCase()}}State {}

class {{feature_name.pascalCase()}}Loading extends {{feature_name.pascalCase()}}State {}

class {{feature_name.pascalCase()}}Loaded extends {{feature_name.pascalCase()}}State {
  final {{feature_name.pascalCase()}}Entity entity;

  const {{feature_name.pascalCase()}}Loaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class {{feature_name.pascalCase()}}Error extends {{feature_name.pascalCase()}}State {
  final String message;

  const {{feature_name.pascalCase()}}Error({required this.message});

  @override
  List<Object?> get props => [message];
}
