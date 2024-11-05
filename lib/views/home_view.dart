
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../view_model/project_view_model.dart';
import 'screens/project_detail_view.dart';
import 'screens/project_list_view.dart';
import 'widgets/project_drawer.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      appBar: AppBar(title: const Text('Gestor de Proyectos')),
      drawer: const DrawerMenu(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape &&
              MediaQuery.of(context).size.width >= 600) {
            return Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: ProjectListView(), // Lista de proyectos
                ),
                const VerticalDivider(width: 1),
                Expanded(flex: 3, child: _buildProjectDetail()),
              ],
            );
          } else {
            return const ProjectListView(); // Solo la lista de proyectos en pantallas pequeñas
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectDetail() {
    return Consumer<ProjectViewModel>(
      builder: (context, projectVM, child) {
        final selectedProject = projectVM.selectedProject;
        if (selectedProject == null) {
          return const Center(
              child: Text('Selecciona un proyecto para ver sus detalles'));
        }
        return ProjectDetailPage(project: selectedProject);
      },
    );
  }

  Future<void> _showAddProjectDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 7));

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
                  'Nuevo Proyecto',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          final project = Project(
                            name: nameController.text,
                            description: descriptionController.text,
                            startDate: startDate,
                            endDate: endDate,
                          );
                          context.read<ProjectViewModel>().addProject(project);
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
}
