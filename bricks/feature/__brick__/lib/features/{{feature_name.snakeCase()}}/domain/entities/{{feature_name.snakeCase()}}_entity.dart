import 'package:equatable/equatable.dart';

class {{feature_name.pascalCase()}}Entity extends Equatable {
  final String id;
  // TODO: Add your entity properties here

  const {{feature_name.pascalCase()}}Entity({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
