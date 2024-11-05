import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project.dart';
import '../../view_model/project_view_model.dart';
import 'project_detail_view.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectViewModel>(
      builder: (context, projectVM, child) {
        // Verifica si hay proyectos, y muestra un mensaje si no hay ninguno.
        if (projectVM.projects.isEmpty) {
          return const Center(
              child: Text('No hay proyectos. ¡Crea uno nuevo!'));
        }

        return ListView.builder(
          itemCount: projectVM.projects.length,
          itemBuilder: (context, index) {
            final project = projectVM.projects[index];
            return ListTile(
              title: Text(project.name),
              subtitle: Text(project.description),
              leading: const Icon(Icons.folder_open),
              selected: projectVM.selectedProject?.id == project.id,
              onTap: () {
                projectVM.selectProject(project);
                // Navega a la página de detalles del proyecto si la pantalla es pequeña
                if (MediaQuery.of(context).size.width < 600) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailPage(project: project),
                    ),
                  );
                }
              },
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Editar')
                    ]),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Eliminar')
                    ]),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditProjectDialog(context, project);
                  } else if (value == 'delete') {
                    // Lógica para eliminar el proyecto
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar Proyecto'),
                        content: const Text(
                            '¿Estás seguro de que quieres eliminar este proyecto?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Llama al método deleteProject con el id del proyecto
                              projectVM.deleteProject(project.id!);
                              Navigator.pop(context);
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> _showEditProjectDialog(
    BuildContext context, Project project) async {
  final nameController = TextEditingController(text: project.name);
  final descriptionController =
      TextEditingController(text: project.description);
  DateTime startDate = project.startDate;
  DateTime endDate = project.endDate;

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Editar Proyecto',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del proyecto',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fechas del proyecto',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    if (!context.mounted) return;
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: startDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      startDate = date;
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  label: const Text(
                                    'Inicio',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    if (!context.mounted) return;
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: endDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      endDate = date;
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  label: const Text(
                                    'Fin',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        final updatedProject = Project(
                          id: project.id, // Mantener el mismo ID
                          name: nameController.text,
                          description: descriptionController.text,
                          startDate: startDate,
                          endDate: endDate,
                        );
                        context
                            .read<ProjectViewModel>()
                            .updateProject(updatedProject);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
