import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/{{feature_name.snakeCase()}}_entity.dart';
import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '../datasources/{{feature_name.snakeCase()}}_remote_datasource.dart';

class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  final {{feature_name.pascalCase()}}RemoteDataSource remoteDataSource;

  {{feature_name.pascalCase()}}RepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> get{{feature_name.pascalCase()}}(String id) async {
    try {
      final model = await remoteDataSource.get{{feature_name.pascalCase()}}(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
