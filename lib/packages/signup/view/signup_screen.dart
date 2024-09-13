import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytodo_0/packages/signup/controller/signup_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GetBuilder<SignupController>(
          init: controller,
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Image.asset(
                      'assets/Images/sign.webp',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Text(
                      '𝚂𝚒𝚐𝚗 𝚄𝚙',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Create your account to REGISTER.')],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: controller.susername,
                      onChanged: (s) => controller.validationerror(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (controller.usernameerror.value.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: Text(
                        controller.usernameerror.value,
                        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      controller: controller.semail,
                      onChanged: (s) => controller.validationerror(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
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
                        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: controller.spassword,
                      onChanged: (s) => controller.validationerror(),
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
                          onPressed: () => controller.visible(),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (controller.passworderror.value.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: Text(
                        controller.passworderror.value,
                        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 20),
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
                                'REGISTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                controller.validationerror();
                                if (controller.usernameerror.value.isEmpty &&
                                    controller.emailerror.value.isEmpty &&
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
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/login');
                        },
                        child: Text('Log in'),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
