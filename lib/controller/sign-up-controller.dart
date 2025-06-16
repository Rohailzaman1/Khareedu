import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:khareedu/model/user-model.dart';

import 'Device-Token-Controller.dart';


class SignupCtroller extends GetxController{

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    DeviceTokenController deviceTokenController = Get.put(DeviceTokenController());

    var isPasswordVisible = false.obs;
    Future<UserCredential?> signUpMethod(
        String userName,
        String userEmail,
        String userPhone,
        String userCity,
        String userPassword,
        String userDeviceToken,
        )async
    {
      try {
        EasyLoading.show(status: "Please Wait...");
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
            email: userEmail,
            password: userPassword);
        EasyLoading.dismiss();
        await userCredential.user!.sendEmailVerification();

        UserModel userModel = UserModel(
            uId: userCredential.user!.uid,
            username:userName,
            email: userEmail,
            phone: userPhone,
            userImg: ' ',
            userDeviceToken: deviceTokenController.Token.toString(),
            country: ' ',
            userAddress: ' ',
            city: ' ',
            street: ' ',
            isAdmin: false,
            isActive: true,
            createdOn: DateTime.now());
        _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
        return userCredential;

      }

      on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
      }
    }
}