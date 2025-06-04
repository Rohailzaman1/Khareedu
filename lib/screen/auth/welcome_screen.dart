import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khareedu/controller/google-sign-in-controller.dart';
import 'package:khareedu/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

import 'SignIn.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});
    final GoogleSignInController _googleSignInController =
        Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Appconst.maincolor,
        title: Text(
          "Welcome To My App",
          style: TextStyle(color: Appconst.Textcolor),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Appconst.secondarycolor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0))),
              child: Lottie.asset('assets/images/splash-icon.json'),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Happy Shopping",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: Get.height/5),
            Material(
              child: Container(
                decoration: BoxDecoration(
                  color: Appconst.secondarycolor,
                  borderRadius: BorderRadius.circular(16)
                ),
                width: Get.width / 1.2,
                height: Get.height / 12,
                child: TextButton.icon(
                  icon: Image.asset('assets/images/google-icon.png',
                    width: Get.width / 11,
                    height: Get.height / 11,),
                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  },
                  label: Text("Sign-In With Google"),
                ),
              ),
            ),
SizedBox(height: Get.height/40),
            Material(
              child: Container(
                decoration: BoxDecoration(
                    color: Appconst.secondarycolor,
                    borderRadius: BorderRadius.circular(16)
                ),
                width: Get.width / 1.2,
                height: Get.height / 12,
                child: TextButton.icon(
                  icon: Image.asset('assets/images/email.png',
                    width: Get.width / 11,
                    height: Get.height / 11,
                  ),
                  onPressed: () {
                    Get.offAll(SignIn());
                  },
                  label: Text("Sign-In With Email"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
