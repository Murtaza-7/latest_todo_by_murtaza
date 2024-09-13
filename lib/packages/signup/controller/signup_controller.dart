import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  TextEditingController semail = TextEditingController();
  TextEditingController susername = TextEditingController();
  TextEditingController spassword = TextEditingController();

  var emailerror = ''.obs;
  var usernameerror = ''.obs;
  var passworderror = ''.obs;

  var isLoading = false.obs;

  bool obscureText = true;

  final RegExp regexcheck = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final RegExp usernameregex = RegExp(r'^[a-zA-Z0-9]+$');

  validationerror() {
    if (semail.text.isEmpty &&
        spassword.text.isEmpty &&
        susername.text.isEmpty) {
      emailerror.value = 'Please enter your email.';
      passworderror.value = 'Please enter your password.';
      usernameerror.value = 'Please enter your username';
    } else {
      if (susername.text.isEmpty) {
        usernameerror.value = 'Please enter your username';
      } else if (!usernameregex.hasMatch(susername.text)) {
        usernameerror.value = 'Invalid username.';
      } else {
        usernameerror.value = '';
      }

      if (semail.text.isEmpty) {
        emailerror.value = 'Please enter your email.';
      } else if (!regexcheck.hasMatch(semail.text)) {
        emailerror.value = 'Invalid email.';
      } else {
        emailerror.value = '';
      }

      if (spassword.text.isEmpty) {
        passworderror.value = 'Please enter your password.';
      } else if (spassword.text.length < 6) {
        passworderror.value = 'Password should 6 character long.';
      } else {
        passworderror.value = '';
      }
    }
    update();
  }

  Future<void>saveusername()async{
    saveuserusername(susername.text);
    update();
  }

  Future<void>saveuserusername(String username)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('susername', username);
    update();
  }

  void visible() {
    obscureText = !obscureText;
    update();
  }

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  void navigateToNextScreen() async {
    setLoading(true);

    await Future.delayed(Duration(seconds: 1));

    Get.offNamed('/home',arguments: {'sourcesignup':'/signup'});

    setLoading(false);
  }

  triggernotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: '✌𝓗𝓲!✌',
      body: '𝐖𝐞𝐥𝐜𝐨𝐦𝐞 𝐭𝐨 𝐌𝐲𝐓𝐨𝐝𝐨 ${susername.text}',
    ));
  }
}
