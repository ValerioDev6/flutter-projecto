import 'package:flutter/foundation.dart';
import '../models/database_helper.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../views/services/notificacion_service.dart';

class ProjectViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();

  List<Project> _projects = [];
  Project? _selectedProject;
  List<Task> _projectTasks = [];
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  List<Task> get projectTasks => _projectTasks;

  Future<void> loadProjects() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('projects');
    _projects = maps.map((map) => Project.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    final db = await _dbHelper.database;
    project.id = await db.insert('projects', project.toMap());
    _projects.add(project);
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    final db = await _dbHelper.database;
    await db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
    int index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  Future<void> deleteProject(int projectId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [projectId],
    );
    _projects.removeWhere((p) => p.id == projectId);
    if (_selectedProject?.id == projectId) {
      _selectedProject = null;
    }
    notifyListeners();
  }

  Future<void> selectProject(Project project) async {
    _selectedProject = project;
    await loadProjectTasks(project.id!);
    notifyListeners();
  }

  Future<void> loadProjectTasks(int projectId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'projectId = ?',
      whereArgs: [projectId],
    );
    _projectTasks = maps.map((map) => Task.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final db = await _dbHelper.database;
    task.id = await db.insert('tasks', task.toMap());
    _projectTasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final db = await _dbHelper.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    int index = _projectTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _projectTasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
    _projectTasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }
}
