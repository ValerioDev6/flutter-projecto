class Task {
  int? id;
  int projectId;
  String title;
  String description;
  DateTime dueDate;
  DateTime? reminderDateTime; // Asegúrate de que esto sea opcional
  bool isCompleted;

  Task({
    this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.reminderDateTime, // Aquí está la nueva propiedad
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'reminderDateTime':
          reminderDateTime?.toIso8601String(), // Incluye reminderDateTime
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      projectId: map['projectId'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      reminderDateTime: map['reminderDateTime'] != null
          ? DateTime.parse(map['reminderDateTime'])
          : null, // Parseo de reminderDateTime
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
