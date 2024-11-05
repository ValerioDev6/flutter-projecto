import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../models/task.dart';
import '../../view_model/project_view_model.dart';
import '../../models/task_list_item.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late ProjectViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ProjectViewModel>(context, listen: false);
    _viewModel.loadProjectTasks(widget.project.id!);
  }

  // Future<void> _showAddTaskDialog() async {
  //   final TextEditingController titleController = TextEditingController();
  //   final TextEditingController descriptionController = TextEditingController();
  //   DateTime selectedDate = DateTime.now();
  //   bool hasAttemptedToSubmit = false;

  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text('Nueva Tarea'),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   TextField(
  //                     controller: titleController,
  //                     decoration: InputDecoration(
  //                       labelText: 'Título*',
  //                       errorText:
  //                           hasAttemptedToSubmit && titleController.text.isEmpty
  //                               ? 'El título es requerido'
  //                               : null,
  //                     ),
  //                     onChanged: (_) {
  //                       if (hasAttemptedToSubmit) {
  //                         setState(
  //                             () {}); // Actualiza el estado para mostrar/ocultar el error
  //                       }
  //                     },
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextField(
  //                     controller: descriptionController,
  //                     decoration:
  //                         const InputDecoration(labelText: 'Descripción'),
  //                     maxLines: 3,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   ListTile(
  //                     title: const Text('Fecha límite'),
  //                     subtitle: Text(
  //                       '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
  //                     ),
  //                     trailing: const Icon(Icons.calendar_today),
  //                     onTap: () async {
  //                       final DateTime? picked = await showDatePicker(
  //                         context: context,
  //                         initialDate: selectedDate,
  //                         firstDate: DateTime.now(),
  //                         lastDate: DateTime(2100),
  //                       );
  //                       if (picked != null) {
  //                         setState(() {
  //                           selectedDate = picked;
  //                         });
  //                       }
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('Cancelar'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     hasAttemptedToSubmit = true;
  //                   });

  //                   if (titleController.text.isEmpty) {
  //                     return;
  //                   }

  //                   final task = Task(
  //                     projectId: widget.project.id!,
  //                     title: titleController.text,
  //                     description: descriptionController.text,
  //                     dueDate: selectedDate,
  //                   );

  //                   _viewModel.addTask(task);
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Guardar'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> _showAddTaskDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    DateTime? selectedReminderDateTime;
    bool hasAttemptedToSubmit = false;
    bool hasReminder = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nueva Tarea'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Título*',
                        errorText:
                            hasAttemptedToSubmit && titleController.text.isEmpty
                                ? 'El título es requerido'
                                : null,
                      ),
                      onChanged: (_) {
                        if (hasAttemptedToSubmit) {
                          setState(() {}); // Update state to show/hide error
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha límite'),
                      subtitle: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Recordatorio'),
                      value: hasReminder,
                      onChanged: (bool value) {
                        setState(() {
                          hasReminder = value;
                          if (!value) {
                            selectedReminderDateTime = null;
                          }
                        });
                      },
                    ),
                    if (hasReminder)
                      ListTile(
                        title: const Text('Fecha y hora del recordatorio'),
                        subtitle: Text(
                          selectedReminderDateTime != null
                              ? '${selectedReminderDateTime!.day}/${selectedReminderDateTime!.month}/${selectedReminderDateTime!.year} ${selectedReminderDateTime!.hour}:${selectedReminderDateTime!.minute.toString().padLeft(2, '0')}'
                              : 'Seleccionar fecha y hora',
                        ),
                        trailing: const Icon(Icons.alarm),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                selectedReminderDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      hasAttemptedToSubmit = true;
                    });

                    if (titleController.text.isEmpty) {
                      return;
                    }

                    final task = Task(
                      projectId: widget.project.id!,
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedDate,
                      reminderDateTime:
                          hasReminder ? selectedReminderDateTime : null,
                    );

                    _viewModel.addTask(task);
                    print(task);
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.edit),
          //   onPressed: () {
          //     // Implementar edición de proyecto
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content:
                      const Text('¿Estás seguro de eliminar este proyecto?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _viewModel.deleteProject(widget.project.id!);
                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Consumer<ProjectViewModel>(
        builder: (context, viewModel, child) {
          final pendingTasks = viewModel.projectTasks
              .where((task) => !task.isCompleted)
              .toList();
          final completedTasks =
              viewModel.projectTasks.where((task) => task.isCompleted).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(widget.project.description),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text('Fecha inicio'),
                              Text(
                                '${widget.project.startDate.day}/${widget.project.startDate.month}/${widget.project.startDate.year}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text('Fecha fin'),
                              Text(
                                '${widget.project.endDate.day}/${widget.project.endDate.month}/${widget.project.endDate.year}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Tareas Pendientes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pendingTasks.length,
                    itemBuilder: (context, index) {
                      final task = pendingTasks[index];
                      return TaskListItem(
                        task: task,
                        onToggleCompletion: () =>
                            viewModel.toggleTaskCompletion(task),
                        onDelete: () => viewModel.deleteTask(task.id!),
                      );
                    },
                  ),
                ),
                if (completedTasks.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Tareas Completadas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = completedTasks[index];
                        return TaskListItem(
                          task: task,
                          onToggleCompletion: () =>
                              viewModel.toggleTaskCompletion(task),
                          onDelete: () => viewModel.deleteTask(task.id!),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
