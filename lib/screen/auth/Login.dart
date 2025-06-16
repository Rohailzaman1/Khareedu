import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khareedu/controller/google-sign-in-controller.dart';
import 'package:khareedu/controller/sign-up-controller.dart';
import 'package:khareedu/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

import 'SignIn.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  SignupCtroller signupController = Get.put(SignupCtroller());
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconst.maincolor,
        centerTitle: true,
        title: Text("Sign In", style: TextStyle(color: Appconst.Textcolor)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                child: Lottie.asset('assets/images/splash-icon.json'),
                decoration: BoxDecoration(
                  color: Appconst.secondarycolor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 10),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: userName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: userEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Obx(
                    () => TextFormField(
                      controller: userPassword,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: signupController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            signupController.isPasswordVisible.toggle();
                          },
                          child: signupController.isPasswordVisible.value
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: userPhone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: userCity,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "City",
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 25),
              Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: Appconst.maincolor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextButton.icon(
                    onPressed: () async {

                      String name = userName.text.trim();
                      String email = userEmail.text.trim();
                      String phone = userPhone.text.trim();
                      String city = userCity.text.trim();
                      String password = userPassword.text.trim();
                      // String userDeviceToken = ' ';
                      String? userDeviceToken = signupController.deviceTokenController.Token;
                      if (name.isEmpty ||
                          email.isEmpty ||
                          phone.isEmpty ||
                          city.isEmpty ||
                          password.isEmpty) {
                        Get.snackbar(
                          snackPosition: SnackPosition.BOTTOM,
                          "Error",
                          "Fill the Detail First",
                          backgroundColor: Appconst.secondarycolor,
                          colorText: Appconst.Textcolor,
                        );
                      } else {
                        UserCredential? userCredential = await signupController
                            .signUpMethod(
                              name,
                              email,
                              phone,
                              city,
                              password,
                              userDeviceToken?? "",
                            );
                        if (userCredential != null) {
                          Get.snackbar(
                            "Error",
                            "Verification Email Sent",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Appconst.secondarycolor,
                            colorText: Appconst.Textcolor,
                          );
                        }
                      }
                    },
                    label: Text("Sign In"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "Already Have An Account?  ",
                      style: TextStyle(color: Appconst.secondarycolor),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => SignIn()),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
