import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Verifica la ruta

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleTaskReminder(
      int taskId, String taskName, DateTime scheduledTime) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_reminder_channel', // ID del canal
      'Task Reminders', // Nombre del canal
      importance: Importance.high,
      priority: Priority.high,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      taskId,
      'Recordatorio de Tarea',
      taskName,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(android: androidPlatformChannelSpecifics),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int taskId) async {
    await flutterLocalNotificationsPlugin.cancel(taskId);
  }
}
