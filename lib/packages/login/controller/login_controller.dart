import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController lpassword = TextEditingController();
  final TextEditingController lemail = TextEditingController();

  var isLoading = false.obs;

  var emailerror = ''.obs;
  var passworderror = ''.obs;

  bool obscureText = true;

  @override
  void onInit() {
    super.onInit();
    loaduseremail();
  }

  Future<void> loaduseremail() async {
    final email = await getuseremail();
    if (email != null) {
      lemail.text = email;
    } else {
      lemail.text = '';
    }
    update();
  }

  void saveemail() {
    saveuseremail(lemail.text);
    update();
  }

  Future<void> saveuseremail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lemail', email);
    update();
  }

  Future<void> savepassword() async {
    saveuserpassword(lpassword.text);
    update();
  }

  Future<void> saveuserpassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lpassword', password);
    update();
  }

  Future<String?> getuseremail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('lemail');
    return email;
  }

  final RegExp regexcheck = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  validationerror() {
    if (lemail.text.isEmpty && lpassword.text.isEmpty) {
      emailerror.value = 'Please enter your email.';
      passworderror.value = 'Please enter your password.';
    } else {
      if (lemail.text.isEmpty) {
        emailerror.value = 'Please enter your email.';
      } else if (!regexcheck.hasMatch(lemail.text)) {
        emailerror.value = 'Invalid email.';
      } else {
        emailerror.value = '';
      }

      if (lpassword.text.isEmpty) {
        passworderror.value = 'Please enter your password.';
      } else if (lpassword.text.length < 6) {
        passworderror.value = 'Password should 6 character long.';
      } else {
        passworderror.value = '';
      }
    }
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
    final prefs = await SharedPreferences.getInstance();

    setLoading(true);
    await Future.delayed(Duration(seconds: 1));

    saveemail();

    Get.offNamed('/home', arguments: {'source': '/login'});
    prefs.setBool('islogin', true);
    setLoading(false);
  }

  triggernotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'welcome',
      title: '✌𝓗𝓲!✌',
      body: '𝐖𝐞𝐥𝐜𝐨𝐦𝐞 𝐭𝐨 𝐌𝐲𝐓𝐨𝐝𝐨 ${lemail.text}',
    ));
  }
}
