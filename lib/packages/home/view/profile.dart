import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytodo_0/packages/home/controller/home_controller.dart';
import 'package:mytodo_0/packages/login/controller/login_controller.dart';
import 'package:mytodo_0/packages/signup/controller/signup_controller.dart';

class userprofile extends StatefulWidget {
  const userprofile({super.key});

  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late homecontrollor homeController;
  late SignupController signupController;
  late LoginController loginController;
  String? useremail;
  String? userpassword;
  String? signusername;

  @override
  void initState() {
    super.initState();

    try {
      homeController = Get.find<homecontrollor>();
      signupController = Get.find<SignupController>();
      loginController = Get.find<LoginController>();

      homeController.requestpermission();
      homeController.loadUserData();
    } catch (e) {
      print('Error finding controllers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(150, 71, 30, 124),
        title: Text(
          '𝘔𝘺 𝘗𝘳𝘰𝘧𝘪𝘭𝘦',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<homecontrollor>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      showImageSourceBottomSheet();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 70,
                      child: _image == null
                          ? Icon(Icons.person, color: Colors.white, size: 70)
                          : ClipOval(
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      Text(
                        'Username:',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    // controller: Get.find<SignupController>().susername,
                    controller: signupController.susername,
                    // onChanged: (s) => controller.validationerror(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 210, 209, 209),
                      errorText: signupController.usernameerror.value.isNotEmpty
                          ? signupController.usernameerror.value
                          : null,
                    ),
                    onChanged: (susername) {
                      signupController.saveusername();
                    },
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    controller: loginController.lemail,
                    // controller: Get.find<LoginController>().lemail,
                    // controller: controller.pemail,
                    // onChanged: (s) => controller.validationerror(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 210, 209, 209),
                      errorText: loginController.emailerror.value.isNotEmpty
                          ? loginController.emailerror.value
                          : null,
                    ),
                    onChanged: (lemail) {
                      loginController.saveemail();
                      // Get.find<LoginController>().saveemail();
                    },
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Password:',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: loginController.lpassword,
                    // controller: Get.find<LoginController>().lpassword,
                    // controller: controller.ppassword,
                    // onChanged: (s) => controller.validationerror(),
                    obscureText: controller.obscureText,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
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
                      filled: true,
                      fillColor: const Color.fromARGB(255, 210, 209, 209),
                      errorText: loginController.passworderror.value.isNotEmpty
                          ? loginController.passworderror.value
                          : null,
                    ),
                    onChanged: (lemail) {
                      loginController.savepassword();
                      // Get.find<LoginController>().savepassword();
                    },
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: Color.fromARGB(150, 71, 30, 124),
                    ),
                    onPressed: () {
                      signupController.validationerror();
                      loginController.validationerror();
                      if (controller.usernameerror.value.isEmpty &&
                          controller.emailerror.value.isEmpty &&
                          controller.passworderror.value.isEmpty) {
                        homeController.saveUserData();
                        Get.offAllNamed('/home');
                        // Get.back(result: _image);
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> showImageSourceBottomSheet() async {
    final pickedfile = await showModalBottomSheet<XFile>(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await _picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop(
                      await _picker.pickImage(source: ImageSource.gallery));
                },
              )
            ],
          ),
        );
      },
    );
    if (pickedfile != null) {
      setState(() {
        _image = File(pickedfile.path);
      });
    }
  }
}
