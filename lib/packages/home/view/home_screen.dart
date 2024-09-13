import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mytodo_0/packages/home/controller/home_controller.dart';
import 'package:mytodo_0/packages/login/controller/login_controller.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late homecontrollor homeController;
  bool ischecked = false;
  String? useremail;
  var tileColor;
  File? _profileImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    try {
      final loginController = Get.put(LoginController(), permanent: true);
      useremail = loginController.lemail.text;
    } catch (e) {
      Get.put(LoginController());
    }

    final arguments = Get.arguments;
    if (arguments != null && arguments is todo) {
      final todo = arguments;
      ischecked = todo.isEditable;
    }

    homeController = Get.put(homecontrollor());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.loadtodo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/Images/menu_image.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('𝙿𝚛𝚘𝚏𝚒𝚕𝚎',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () async {
                Get.toNamed('/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('𝙻𝚘𝚐𝚘𝚞𝚝',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () async {
                bool shouldLogout = await alertlogout(context, useremail ?? '');
                if (shouldLogout) {
                  await homeController.removedata();
                  Get.offAllNamed('/login');
                }
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey,
                child: _profileImage == null
                    ? IconButton(
                        onPressed: () async {

                          // final result = await Get.toNamed('/profile');
                          // if (result is File) {
                          //   setState(() {
                          //     _profileImage = result;
                          //   });
                          // }
                        },
                        icon: Icon(Icons.person),
                        color: Colors.white,
                        iconSize: 15,
                      )
                    : ClipOval(
                        child: GestureDetector(
                          onTap: (){
                          showmiddleimage();
                          },
                          child: Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                            width: 30,
                            height: 30,
                          ),
                        ) 
                        // Image.file(
                        //   _profileImage!,
                        //   fit: BoxFit.cover,
                        //   width: 30,
                        //   height: 30,
                        // ),
                      )),
          ),
        ],
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          color: Colors.white,
          icon: Icon(Icons.menu),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 51, 3, 98),
        title: Text(
          '📄 𝑴𝒚𝑻𝒐𝒅𝒐\'𝒔 🖊️',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<homecontrollor>(
        builder: (controller) {
          if (controller.todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    width: 325,
                    height: 325,
                    'assets/Animations/Animation - 1724230091259.json',
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'ʏᴏᴜʀ ᴛᴏ-ᴅᴏ ɪꜱ ᴇᴍᴘᴛʏ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.separated(
              itemCount: controller.todos.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 1.5,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final todo = controller.todos[index];
                DateTime dateTime = DateTime.parse(todo.date);
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/details', arguments: todo);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        subtitle:
                            Text('${homeController.formatDate(dateTime)} at ${todo.time}'),
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                          backgroundColor: Color.fromARGB(255, 51, 3, 98),
                          foregroundColor: Colors.white,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: todo.ischecked,
                              onChanged: (bool? value) async {
                                bool shouldchange = await alertcheck(context);
                                if (shouldchange) {
                                  homeController.updateTodo(
                                      todo.copyWith(ischecked: value ?? false));
                                }
                              },
                            ),
                            if (todo.isEditable)
                              IconButton(
                                onPressed: () {
                                  Get.toNamed('/add', arguments: todo);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 51, 3, 98),
                                ),
                              ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool shouldDelete =
                                    await _confirmDelete(context);
                                if (shouldDelete) {
                                  controller.removetodo(todo.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 51, 3, 98),
        onPressed: () {
          Get.toNamed("/add");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void showmiddleimage(){
   
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you want to delete this TO-DO?'),
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
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    return shouldDelete ?? false;
  }
}

Future<bool> alertlogout(BuildContext context, String lemail) async {
  bool? shouldLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('$lemail\nAre you sure you want to Logout?'),
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
            onPressed: () {
              Navigator.pop(context, true);
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
  );
  return shouldLogout ?? false;
}

Future<bool> alertcheck(BuildContext context) async {
  bool? shouldchange = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text('Do you want to update your status?'),
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
            onPressed: () {
              Navigator.pop(context, true);
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
  );
  return shouldchange ?? false;
}
