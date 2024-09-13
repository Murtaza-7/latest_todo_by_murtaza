import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo_0/packages/background_services/background_services.dart';
import 'package:mytodo_0/packages/home/controller/home_controller.dart';
import 'package:mytodo_0/packages/home/view/addtodo_screen.dart';
import 'package:mytodo_0/packages/home/view/home_screen.dart';
import 'package:mytodo_0/packages/home/view/homedetails_screen.dart';
import 'package:mytodo_0/packages/home/view/profile.dart';
import 'package:mytodo_0/packages/login/controller/login_controller.dart';
import 'package:mytodo_0/packages/login/view/login_screen.dart';
import 'package:mytodo_0/packages/signup/controller/signup_controller.dart';
import 'package:mytodo_0/packages/signup/view/signup_screen.dart';
import 'package:mytodo_0/packages/splash/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(homecontrollor());
  Get.put(LoginController());
  Get.put(SignupController());
  
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await initializeServices();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'kbkejbkjecbkj',
        importance: NotificationImportance.High,
        playSound: true,
        enableVibration: true,
        soundSource: 'resource://raw/notification',
      ),
      NotificationChannel(
        channelKey: 'welcome',
        channelName: 'ff',
        channelDescription: 'rrr',
        importance: NotificationImportance.High,
        playSound: true,
        enableVibration: true,
      )
    ],
    debug: true,
  );

  Get.put(LoginController(), permanent: true);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => Splash(),
      '/home': (context) => home(),
      '/login': (context) => login(),
      '/signup': (context) => Signup(),
      '/details': (context) => homedetails(),
      '/add': (context) => add(),
      '/profile': (context) => userprofile(),
    },
  ));
}
