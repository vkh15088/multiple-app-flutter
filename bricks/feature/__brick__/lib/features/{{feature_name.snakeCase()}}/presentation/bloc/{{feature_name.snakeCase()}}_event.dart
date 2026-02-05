part of '{{feature_name.snakeCase()}}_bloc.dart';

abstract class {{feature_name.pascalCase()}}Event extends Equatable {
  const {{feature_name.pascalCase()}}Event();

  @override
  List<Object?> get props => [];
}

class {{feature_name.pascalCase()}}LoadRequested extends {{feature_name.pascalCase()}}Event {
  final String id;

  const {{feature_name.pascalCase()}}LoadRequested({required this.id});

  @override
  List<Object?> get props => [id];
}
