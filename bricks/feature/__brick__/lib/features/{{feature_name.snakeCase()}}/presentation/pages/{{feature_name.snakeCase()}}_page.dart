import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/{{feature_name.snakeCase()}}_bloc.dart';

class {{feature_name.pascalCase()}}Page extends StatelessWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_name.titleCase()}}'),
      ),
      body: BlocBuilder<{{feature_name.pascalCase()}}Bloc, {{feature_name.pascalCase()}}State>(
        builder: (context, state) {
          if (state is {{feature_name.pascalCase()}}Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is {{feature_name.pascalCase()}}Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is {{feature_name.pascalCase()}}Loaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('{{feature_name.pascalCase()}} ID: ${state.entity.id}'),
                  // TODO: Display your entity data here
                ],
              ),
            );
          }

          return const Center(
            child: Text('Load {{feature_name.snakeCase()}} data'),
          );
        },
      ),
    );
  }
}
