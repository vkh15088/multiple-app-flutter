import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/{{feature_name.snakeCase()}}_entity.dart';

abstract class {{feature_name.pascalCase()}}Repository {
  Future<Either<Failure, {{feature_name.pascalCase()}}Entity>> get{{feature_name.pascalCase()}}(String id);
}
