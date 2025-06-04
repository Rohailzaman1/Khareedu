import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khareedu/controller/forget-password-controller.dart';
import 'package:khareedu/controller/sign-in-controller.dart';
import 'package:khareedu/controller/sign-up-controller.dart';
import 'package:khareedu/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

import 'Login.dart';
class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}
class _forgetPasswordState extends State<forgetPassword> {
  final forgetPasswordController forgetPassword = Get.put(forgetPasswordController());
  final TextEditingController Email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        centerTitle: true,
        title: Text("Forget Password",style: TextStyle(color: Appconst.Textcolor),),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Lottie.asset('assets/images/splash-icon.json'),
                decoration: BoxDecoration(color: Appconst.secondarycolor, borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0))),
              ),
              SizedBox(height: Get.height/10,),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: Email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                  ),
                ),

              ),

              SizedBox(height: Get.height/25,),
              Material(
                child: Container(
                  decoration: BoxDecoration(
                      color: Appconst.maincolor,
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      String email = Email.text.trim();
                      forgetPassword.forgetpassword(email);
                    },
                    label: Text("Forget"),
                  ),
                ),
              ),
              SizedBox(height: Get.height/12,),
            ],
          ),

        ),
      ),


    );
  }
}
