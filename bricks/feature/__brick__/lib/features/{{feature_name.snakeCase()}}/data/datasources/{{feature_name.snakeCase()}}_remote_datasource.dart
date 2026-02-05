import '../models/{{feature_name.snakeCase()}}_model.dart';

abstract class {{feature_name.pascalCase()}}RemoteDataSource {
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}(String id);
}

class {{feature_name.pascalCase()}}RemoteDataSourceImpl implements {{feature_name.pascalCase()}}RemoteDataSource {
  // TODO: Add your dependencies (e.g., HTTP client, Firebase, etc.)
  
  {{feature_name.pascalCase()}}RemoteDataSourceImpl();

  @override
  Future<{{feature_name.pascalCase()}}Model> get{{feature_name.pascalCase()}}(String id) async {
    try {
      // TODO: Implement API call to get {{feature_name.snakeCase()}}
      throw UnimplementedError('get{{feature_name.pascalCase()}} not implemented');
    } catch (e) {
      throw Exception('Failed to get {{feature_name.snakeCase()}}: $e');
    }
  }
}
