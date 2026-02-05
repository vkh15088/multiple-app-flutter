import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';

class {{feature_name.pascalCase()}}Model extends {{feature_name.pascalCase()}}Entity {
  const {{feature_name.pascalCase()}}Model({
    required super.id,
  });

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) {
    return {{feature_name.pascalCase()}}Model(
      id: json['id'] as String,
      // TODO: Add your model properties from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // TODO: Add your model properties to JSON
    };
  }

  {{feature_name.pascalCase()}}Entity toEntity() {
    return {{feature_name.pascalCase()}}Entity(
      id: id,
      // TODO: Add your entity properties
    );
  }
}
