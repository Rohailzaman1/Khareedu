import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khareedu/controller/user-Data-Controller.dart';
import 'package:khareedu/screen/admin-panel/admin-Panel.dart';
import 'package:khareedu/screen/user-panel/main-screen.dart';

import 'package:khareedu/utils/app-constant.dart';
import 'package:lottie/lottie.dart';
import 'welcome_screen.dart';
class SplashScreen extends StatefulWidget {
   SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Get.offAll(WelcomeScreen());
      loggin(context);
    });
  }
    Future<void> loggin(BuildContext context) async
    {
      UserDataController userDataController = Get.put(UserDataController());
      var userdata =  await userDataController.getUserData(user!.uid);
          if(user != null)
            {
                if(userdata[0]['isAdmin']== true)
                  {
                    Get.offAll(Admin_panel());
                  }
                else
                  {
                    Get.offAll(MainScreen());
                  }
            }
          else
            {
              Get.offAll(MainScreen());
            }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appconst.secondarycolor,
      appBar: AppBar(backgroundColor: Appconst.maincolor),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Lottie.asset('assets/images/splash-icon.json'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: Get.width,
              alignment: Alignment.center,
              child: Text(
                Appconst.AppPoweredBy,
                style: TextStyle(
                  fontSize: 20,
                  color: Appconst.Textcolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
