import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/{{feature_name.snakeCase()}}_entity.dart';
import '../repositories/{{feature_name.snakeCase()}}_repository.dart';

class Get{{feature_name.pascalCase()}}UseCase implements UseCase<{{feature_name.pascalCase()}}Entity, {{feature_name.pascalCase()}}Params> {
  final {{feature_name.pascalCase()}}Repository repository;

  Get{{feature_name.pascalCase()}}UseCase(this.repository);

  @override
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> call({{feature_name.pascalCase()}}Params params) async {
    return await repository.get{{feature_name.pascalCase()}}(params.id);
  }
}


class {{feature_name.pascalCase()}}Params {
  final String id;

  {{feature_name.pascalCase()}}Params({required this.id});
}

