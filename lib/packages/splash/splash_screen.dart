import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      var IsLogin = prefs.getBool('islogin') ?? false;
      if (IsLogin) {
        Get.offAllNamed("/home");
      } else {
        Get.offAllNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(243, 255, 255, 255),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 80),
            Image.asset('assets/Images/Todo_splash.jpg'),
            SizedBox(height: 20),
            Text(
              '𝚆𝚎𝚕𝚌𝚘𝚖𝚎 𝚝𝚘 𝚃𝙾-𝙳𝙾 𝙰𝚙𝚙',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  '𝚈𝚘𝚞𝚛 𝚎𝚊𝚜𝚢 𝚠𝚊𝚢 𝚝𝚘 𝚜𝚝𝚊𝚢 𝚘𝚛𝚐𝚊𝚗𝚒𝚣𝚎𝚍 𝚊𝚗𝚍 𝚐𝚎𝚝 𝚝𝚑𝚒𝚗𝚐𝚜 𝚍𝚘𝚗𝚎. 𝙼𝚊𝚗𝚊𝚐𝚎 𝚝𝚊𝚜𝚔𝚜, 𝚜𝚎𝚝 𝚛𝚎𝚖𝚒𝚗𝚍𝚎𝚛𝚜, 𝚊𝚗𝚍 𝚋𝚘𝚘𝚜𝚝 𝚢𝚘𝚞𝚛 𝚙𝚛𝚘𝚍𝚞𝚌𝚝𝚒𝚟𝚒𝚝𝚢 𝚠𝚒𝚝𝚑 𝚓𝚞𝚜𝚝 𝚊 𝚏𝚎𝚠 𝚝𝚊𝚙𝚜.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(height: 15),
            Container(
              child: Text(
                '𝙻𝚎𝚝’𝚜 𝚝𝚊𝚌𝚔𝚕𝚎 𝚢𝚘𝚞𝚛 𝚃𝙾-𝙳𝙾 𝚕𝚒𝚜𝚝 𝚝𝚘𝚐𝚎𝚝𝚑𝚎𝚛❗',
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 3, 98),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
