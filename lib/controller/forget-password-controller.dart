import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:khareedu/utils/app-constant.dart';

import '../screen/auth/SignIn.dart';

class forgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> forgetpassword(String userEmail) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "Message: ",
        "Please Check Your Email Address "
            "Email is Sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Appconst.Textcolor,
        backgroundColor: Appconst.secondarycolor,
      );
      Get.offAll(SignIn());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
