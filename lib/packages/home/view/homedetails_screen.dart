import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo_0/packages/home/controller/home_controller.dart';

class homedetails extends StatefulWidget {
  const homedetails({super.key});

  @override
  State<homedetails> createState() => _homedetailsState();
}

class _homedetailsState extends State<homedetails> {
  bool ischecked = false;
  @override
  Widget build(BuildContext context) {
    final todo1 = Get.arguments as todo;
    final arguments = Get.arguments;
    if (arguments != null && arguments is todo) {
      final todo = arguments;
      ischecked = todo.ischecked;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Get.offAllNamed('/home');
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Color.fromARGB(255, 51, 3, 98),
        centerTitle: true,
        title: Text(
          '𝗗𝗘𝗧𝗔𝗜𝗟𝗦',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(255, 71, 30, 124),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '𝚃𝚒𝚝𝚕𝚎:',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${todo1.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 29,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(235, 71, 30, 124),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '𝙳𝚎𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗:',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${todo1.description}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(205, 71, 30, 124),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        '𝙳𝚊𝚝𝚎: ${todo1.date}',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(170, 71, 30, 124),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        '𝚃𝚒𝚖𝚎: ${todo1.time}',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(150, 71, 30, 124),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        ischecked
                            ? '𝚂𝚝𝚊𝚝𝚞𝚜: ᴄᴏᴍᴘʟᴇᴛᴇᴅ'
                            : '𝚂𝚝𝚊𝚝𝚞𝚜: ᴘᴇɴᴅɪɴɢ',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
