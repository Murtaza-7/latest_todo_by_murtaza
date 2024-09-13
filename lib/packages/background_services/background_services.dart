import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mytodo_0/packages/home/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeServices() async {
  final services = FlutterBackgroundService();

  await services.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
    ),
  );
  await services.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // if (service is AndroidServiceInstance) {
  //   service.on('setAsForeground').listen((event) {
  //     service.setAsForegroundService();
  //   });

  //   service.on('setAsBackground').listen((event) {
  //     service.setAsBackgroundService();
  //   });
  // }

  // service.on('stopServices').listen((event) {
  //   print('----------->>>>>>>>>>>>>....');
  //   service.stopSelf();
  // });

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: 'Todo Checker',
          content: 'Checking for Todo reminders...',
        );
      }
    }
    await checkTodos();
    service.invoke('update');
  });
}

// Future<void> showNotification(String todoTitle) async {
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 10,
//       channelKey: 'basic_channel',
//       title: 'Todo Reminder',
//       body: todoTitle,
//       notificationLayout: NotificationLayout.Default,
//     ),
//   );
// }

Future<void> checkTodos() async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now().toIso8601String();
  final keys = prefs.getKeys();

  for (var key in keys) {
    if (key.startsWith('todo_')) {
      final savedDateTimeString = key.substring(5);
      DateTime.parse(savedDateTimeString);

      if (now.startsWith(savedDateTimeString)) {
        final todosJsonList = prefs.getStringList('todos');
        if (todosJsonList != null) {
          for (var jsonString in todosJsonList) {
            final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
            final todoItem = todo.fromJson(jsonMap);
            if (todoItem.dateTime != null &&
                todoItem.dateTime!.isBefore(DateTime.now())) {
             print('Todo Reminder:${todoItem.title}');
            }
          }
        }
      }
    }
  }
}

Future<void> scheduleNotification(
    String title, String description, String date, String time) async {
  try {
    print('Date input: $date');
    print('Time input: $time');

    final dateParts = date.split('-');
    if (dateParts.length != 3) {
      throw FormatException('Invalid date format. Expected YYYY-MM-DD');
    }

    final year = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final day = int.tryParse(dateParts[2]);

    if (year == null ||
        month == null ||
        day == null ||
        year < 1000 ||
        year > 9999 ||
        month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 31) {
      throw FormatException(
          'Invalid date values. Ensure the date is in the format YYYY-MM-DD');
    }

    final timeParts = time.split(' ');
    if (timeParts.length != 2) {
      throw FormatException('Invalid time format. Expected HH:MM AM/PM');
    }

    final timeString = timeParts[0];
    final amPm = timeParts[1].toUpperCase();

    final timeComponents = timeString.split(':');
    if (timeComponents.length != 2) {
      throw FormatException('Invalid time format. Expected HH:MM');
    }

    final hour = int.tryParse(timeComponents[0]);
    final minute = int.tryParse(timeComponents[1]);

    if (hour == null ||
        minute == null ||
        hour < 1 ||
        hour > 12 ||
        minute < 0 ||
        minute > 59) {
      throw FormatException(
          'Invalid time values. Ensure the time is in the format HH:MM AM/PM');
    }

    int hour24 = hour;
    if (amPm == 'PM' && hour != 12) {
      hour24 += 12;
    }
    if (amPm == 'AM' && hour == 12) {
      hour24 = 0;
    }

    DateTime now = DateTime.now();
    DateTime notificationTime = DateTime(
      year,
      month,
      day,
      hour24,
      minute,
    );

    if (notificationTime.isBefore(now)) {
      print('Notification time is in the past.');
      return;
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: 'ᴛᴏᴅᴏ ʀᴇᴍɪɴᴅᴇʀ...',
        body: '$title\nReminder: $description',
        customSound: 'resource://raw/notification',
        wakeUpScreen: true,
      ),
      schedule: NotificationCalendar(
        year: notificationTime.year,
        month: notificationTime.month,
        day: notificationTime.day,
        hour: notificationTime.hour,
        minute: notificationTime.minute,
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
      ),
    );
    print('Notification scheduled for ${notificationTime.toLocal()}');
  } catch (e) {
    print('Error scheduling notification: $e');
  }
}
