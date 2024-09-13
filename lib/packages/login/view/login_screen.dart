import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo_0/packages/login/controller/login_controller.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final controller = Get.put(LoginController());
  void initState(){
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GetBuilder<LoginController>(
          init: controller,
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Image.asset(
                      'assets/Images/login.webp',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Text(
                      '𝐖𝐞𝐥𝐜𝐨𝐦𝐞 𝐁𝐚𝐜𝐤!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Enter to LOGIN.'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      controller: controller.lemail,
                      onChanged: (value) {
                        controller.validationerror();
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (controller.emailerror.value.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: Text(
                        controller.emailerror.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: controller.lpassword,
                      onChanged: (p) {
                        controller.validationerror();
                      },
                      obscureText: controller.obscureText,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: controller.visible,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (controller.passworderror.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21.0),
                      child: Text(
                        controller.passworderror.value,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 15),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 100),
                      child: controller.isLoading.value
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                controller.validationerror();
                                if (controller.emailerror.value.isEmpty &&
                                    controller.passworderror.value.isEmpty) {
                                  controller.navigateToNextScreen();
                                  controller.triggernotification();
                                }
                              },
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/signup');
                        },
                        child: Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
