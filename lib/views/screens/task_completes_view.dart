import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../view_model/project_view_model.dart';

class TareasCompletadasView extends StatefulWidget {
  const TareasCompletadasView({super.key});

  @override
  State<TareasCompletadasView> createState() => _TareasCompletadasViewState();
}

class _TareasCompletadasViewState extends State<TareasCompletadasView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectViewModel>().loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Completadas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProjectViewModel>(
        builder: (context, projectViewModel, child) {
          List<Task> allCompletedTasks = [];

          for (var project in projectViewModel.projects) {
            projectViewModel.loadProjectTasks(project.id!);
            allCompletedTasks.addAll(projectViewModel.projectTasks
                .where((task) => task.isCompleted));
          }

          if (allCompletedTasks.isEmpty) {
            return const Center(
              child: Text(
                'No hay tareas completadas',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: allCompletedTasks.length,
            itemBuilder: (context, index) {
              final task = allCompletedTasks[index];
              final project = projectViewModel.projects.firstWhere(
                (p) => p.id == task.projectId,
                orElse: () => throw Exception('Proyecto no encontrado'),
              );

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    'Descripción: ${task.description}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    'Proyecto: ${project.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
