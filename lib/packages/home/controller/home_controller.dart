import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homecontrollor extends GetxController {
  TextEditingController controller1 = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController pemail = TextEditingController();
  TextEditingController pusername = TextEditingController();
  TextEditingController ppassword = TextEditingController();

  var emailerror = ''.obs;
  var usernameerror = ''.obs;
  var passworderror = ''.obs;

  var titleerror = ''.obs;
  var descriptionerror = ''.obs;
  var timeerror = ''.obs;

  var todos = <todo>[].obs;
  bool toastshown = false;
  String? naviagtionsource;
  String? naviagtionsourcesignup;
  final ImagePicker _picker = ImagePicker();
  bool showanimation = false;
  bool obscureText = true;

  final RegExp regexcheck = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  final RegExp usernameregex = RegExp(r'^[a-zA-Z0-9]+$');

  validationerror() {
    if (pemail.text.isEmpty &&
        ppassword.text.isEmpty &&
        pusername.text.isEmpty) {
      emailerror.value = 'Please enter your email.';
      passworderror.value = 'Please enter your password.';
      usernameerror.value = 'Please enter your username';
    } else {
      if (pusername.text.isEmpty) {
        usernameerror.value = 'Please enter your username';
      } else if (!usernameregex.hasMatch(pusername.text)) {
        usernameerror.value = 'Invalid username.';
      } else {
        usernameerror.value = '';
      }

      if (pemail.text.isEmpty) {
        emailerror.value = 'Please enter your email.';
      } else if (!regexcheck.hasMatch(pemail.text)) {
        emailerror.value = 'Invalid email.';
      } else {
        emailerror.value = '';
      }

      if (ppassword.text.isEmpty) {
        passworderror.value = 'Please enter your password.';
      } else if (ppassword.text.length < 6) {
        passworderror.value = 'Password should 6 character long.';
      } else {
        passworderror.value = '';
      }
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadtodo();

    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      naviagtionsource = arguments['source'];
      naviagtionsourcesignup = arguments['sourcesignup'];
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showtoast();
    // });
  }

  Future<void> saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', pemail.text);
      await prefs.setString('username', pusername.text);
      await prefs.setString('password', ppassword.text);
    } catch (e) {
      print('Error saving user data: $e');
      Get.snackbar('Error', 'Failed to save changes');
    }
    update();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    pemail.text = prefs.getString('email') ?? '';
    pusername.text = prefs.getString('username') ?? '';
    ppassword.text = prefs.getString('password') ?? '';
    update();
  }

  validationhome() {
    if (title.text.isEmpty) {
      titleerror.value = 'Your Title is Empty!';
    }
    update();
    if (description.text.isEmpty) {
      descriptionerror.value = 'Your Description is Empty!';
    }
    update();
    if (time.text.isEmpty) {
      timeerror.value = 'Select Time!';
    }
    update();
  }

  void visible() {
    obscureText = !obscureText;
    update();
  }

  Future<void> ad(
    var title,
    var description,
    var time,
    var date,
    bool ischecked,
  ) async {
    final newtodo = todo(
      id: todos.length,
      title: title,
      description: description,
      date: date,
      time: time,
      isEditable: true,
      ischecked: ischecked,
    );
    todos.add(newtodo);

    await savetodo();
    Get.toNamed('/home', arguments: {'source': '/home'});
    update();
  }

  void removetodo(int id) {
    todos.removeWhere((todo) => todo.id == id);
    for (int i = 0; i < todos.length; i++) {
      todos[i] = todos[i].copyWith(id: i);
    }
    savetodo();
    update();
  }

  Future<void> updateTodo(todo updatedTodo) async {
    final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      todos[index] = updatedTodo;
      await savetodo();
      Get.toNamed('/home', arguments: {'source': '/home'});
      update();
    }
  }

  Future<void> savetodo() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todosJsonList =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', todosJsonList);
    update();
  }

  Future<void> loadtodo() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todosJsonList = prefs.getStringList('todos');
    if (todosJsonList != null) {
      todos.value = todosJsonList.map((jsonString) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return todo.fromJson(jsonMap);
      }).toList();
      print('todo json list $todosJsonList');
      update();
    } else {
      todos.value = [];
      update();
    }
  }

  Future<void> removedata() async {
    final prefs = await SharedPreferences.getInstance();
    print('Current todo before clearing: ${prefs.getStringList('todos')}');
    await prefs.remove('todos');
    await prefs.remove('islogin');
    Get.offAllNamed('/login');
  }

  showtoast() {
    if (!toastshown) {
      if(naviagtionsource=='/add'){
        Fluttertoast.showToast(msg: 'Successfully Added!');
      }
      // if (naviagtionsource == '/login') {
      //   Fluttertoast.showToast(msg: 'Successfully Logged In!');
      // } else if (naviagtionsourcesignup == '/signup') {
      //   Fluttertoast.showToast(msg: 'Successfully Registered!');
      // }
      toastshown = false;
      update();
    }
  }

  Future<DateTime?> selectdate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? datePicked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 51, 3, 98),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Color.fromARGB(255, 51, 3, 98),
              headerForegroundColor: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 51, 3, 98)),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    return datePicked;
  }

  Future<TimeOfDay?> selecttime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 51, 3, 98),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Color.fromARGB(255, 51, 3, 98),
              headerForegroundColor: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 51, 3, 98)),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    return pickedTime;
  }

  String formatTime(DateTime datetime) {
    final hour = datetime.hour;
    final minute = datetime.minute;
    final ampm = datetime.hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    final formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $ampm';
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {}
    update();
  }

  Future<void> requestpermission() async {
    final camerastatus = await Permission.camera.request();
    final storagestatus = await Permission.storage.request();

    if (!camerastatus.isGranted || !storagestatus.isGranted) {}
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }
}

class todo {
  int id;
  final String title;
  String description;
  String time;
  String date;
  bool isEditable;
  bool ischecked;
  final DateTime? dateTime;

  todo({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.isEditable,
    this.ischecked = false,
    this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'isEditable': isEditable,
      'isChecked': ischecked,
    };
  }

  factory todo.fromJson(Map<String, dynamic> json) {
    return todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: json['time'],
      date: json['date'],
      isEditable: json['isEditable'],
      ischecked: json['isChecked'],
    );
  }
  todo copyWith(
      {int? id,
      String? title,
      String? description,
      String? time,
      String? date,
      bool? isEditable,
      bool? ischecked}) {
    return todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        time: time ?? this.time,
        date: date ?? this.date,
        isEditable: isEditable ?? this.isEditable,
        ischecked: ischecked ?? this.ischecked);
  }
}
