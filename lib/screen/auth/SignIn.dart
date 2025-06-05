import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khareedu/controller/google-sign-in-controller.dart';
import 'package:khareedu/controller/sign-in-controller.dart';
import 'package:khareedu/controller/sign-up-controller.dart';
import 'package:khareedu/controller/user-Data-Controller.dart';
import 'package:khareedu/utils/app-constant.dart';
import 'package:lottie/lottie.dart';

import '../user-panel/main-screen.dart';
import 'Login.dart';
import 'forgetPassword.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SignupCtroller signupController = Get.put(SignupCtroller());
  SignInController signInController = Get.put(SignInController());
  UserDataController userDataController = Get.put(UserDataController());

  TextEditingController userEmail = TextEditingController();
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
                          ()=>TextFormField(
                        controller: userPassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: signupController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: GestureDetector(
                              onTap: ()
                              {
                                signupController.isPasswordVisible.toggle();
                              },
                              child:
                              signupController.isPasswordVisible.value
                                  ?   Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      )
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
                      String email = userEmail.text.trim();
                      String password = userPassword.text.trim();
                      String userDeviceToken = ' ';
                      if(email.isEmpty || password.isEmpty)
                      {
                        Get.snackbar(
                            snackPosition: SnackPosition.BOTTOM,
                            "Error", "Fill the Detail First",
                            backgroundColor: Appconst.secondarycolor,
                            colorText: Appconst.Textcolor
                        );
                      }
                      else {
                        UserCredential? userCredential = await signInController
                            .signInMethod(
                            email,
                            password);

                        if(userCredential != null)
                        {
                          if(userCredential.user!.emailVerified)
                            {
                              Get.offAll(()=>MainScreen());

                              Get.snackbar("Error", "Login Successfully",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Appconst.secondarycolor,
                                  colorText: Appconst.Textcolor);
                            }
                          else {
                            Get.snackbar("Error", "Verification Email Sent",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Appconst.secondarycolor,
                                colorText: Appconst.Textcolor
                            );
                          }
                        }
                        else
                          {
                            Get.snackbar("Error", "Please Verify Your Email First",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Appconst.secondarycolor,
                                colorText: Appconst.Textcolor
                            );
                          }
                      }
                    },
                    label: Text("Login"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: ()=> Get.offAll(()=>forgetPassword()),
                        child: Text("Forget Password",style: TextStyle(color: Appconst.secondarycolor),)),
                    GestureDetector(
                        onTap: ()=>Get.offAll(()=>Login()),
                        child: Text("Register"))
                    
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


