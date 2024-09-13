import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:mytodo_0/packages/background_services/background_services.dart';
import 'package:mytodo_0/packages/home/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  late homecontrollor homecontroller;
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  bool ischecked = false;
  bool _isEditMode = false;

  late int _todoId;

  @override
  void initState() {
    super.initState();

    homecontroller = Get.put(homecontrollor());
    
    final arguments = Get.arguments;
    if (arguments != null && arguments is todo) {
      final todo = arguments;
      _isEditMode = true;
      _todoId = todo.id;
      _titlecontroller.text = todo.title;
      _descriptioncontroller.text = todo.description;
      ischecked = todo.ischecked;
    }
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _descriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homecontrollor homecontroller = Get.find<homecontrollor>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Get..offAllNamed('/home');
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color.fromARGB(255, 51, 3, 98),
        centerTitle: true,
        title: Text(
          _isEditMode ? 'ᴇᴅɪᴛ ᴛᴏ-ᴅᴏ' : 'ᴀᴅᴅ ᴛᴏ-ᴅᴏ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'TITLE:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                maxLength: 20,
                controller: _titlecontroller,
                decoration: InputDecoration(
                  labelText: 'Enter your Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'DESCRIPTION:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  TextFormField(
                    controller: _descriptioncontroller,
                    maxLines: 8,
                    decoration: InputDecoration(
                        labelText: 'Enter your Description...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Select Date:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _datecontroller,
                      decoration: InputDecoration(
                          counterText: '',
                          prefixIcon: Icon(Icons.calendar_month),
                          labelText: 'YYYY/MM/DD',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      readOnly: true,
                      onTap: () async {
                        DateTime? selecteddate =
                            await homecontroller.selectdate(context);
                        if (selecteddate != null) {
                          _datecontroller.text =
                              '${selecteddate.toLocal()}'.split(' ')[0];
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Select Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _timecontroller,
                decoration: InputDecoration(
                    labelText: 'HH:MM',
                    counterText: '',
                    prefixIcon: Icon(Icons.alarm),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                  LengthLimitingTextInputFormatter(5),
                ],
                readOnly: true,
                onTap: () async {
                  TimeOfDay? selectedtime =
                      await homecontroller.selecttime(context);
                  if (selectedtime != null) {
                    final now = DateTime.now();
                    final datetime = DateTime(now.year, now.month, now.day,
                        selectedtime.hour, selectedtime.minute);
                    _timecontroller.text = homecontroller.formatTime(datetime);
                  }
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'STATUS:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    ischecked ? 'Completed' : 'Pending',
                    style: TextStyle(
                        color: ischecked ? Colors.green : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 51, 3, 98),
                ),
                onPressed: () async {
                  final title = _titlecontroller.text;
                  final description = _descriptioncontroller.text;
                  final time = _timecontroller.text;
                  final date = _datecontroller.text;

                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      time.isNotEmpty) {
                    bool shouldsave = await showAlertDialog();
                    if (shouldsave) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('todotitle', title);
                      await prefs.setString('tododescription', description);
                      await prefs.setString('tododate', date);
                      await prefs.setString('todotime', time);

                      if (_isEditMode) {
                        homecontroller.updateTodo(todo(
                          id: _todoId,
                          title: title,
                          description: description,
                          time: time,
                          date: date,
                          isEditable: ischecked,
                          ischecked: ischecked,
                        ));
                      } else {
                        homecontroller.ad(
                            title, description, time, date, ischecked);
                        // // homecontroller.validationhome();
                        // await scheduleNotification(
                        //     title, description, date, time);
                        await scheduleNotification(
                            title, description, date, time);
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all the fields')));
                  }
                },
                child: Text(
                  _isEditMode ? 'Edit TO-DO ✎' : 'Add TO-DO ⊹',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showAlertDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                  'Are you sure you want to ${_isEditMode ? 'save changes to' : 'add'} this TO-DO?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Color.fromARGB(255, 51, 3, 98),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                    final service = FlutterBackgroundService();
                    bool isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke('stopService');
                    } else {
                      service.startService();
                    }
                    setState(() {});
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Color.fromARGB(255, 51, 3, 98),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
