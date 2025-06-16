import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:khareedu/model/user-model.dart';
import 'package:khareedu/screen/user-panel/main-screen.dart';

import 'Device-Token-Controller.dart';



class GoogleSignInController extends GetxController
{
  final GoogleSignIn gooogleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DeviceTokenController deviceTokenController = Get.put(DeviceTokenController());
  Future<void> signInWithGoogle()async
  {
    try{
      final GoogleSignInAccount? googleSignInAccount =
       await  gooogleSignIn.signIn();

      if(googleSignInAccount !=  null)
      EasyLoading.show(status: "Please Wait....");
        {
      final GoogleSignInAuthentication googleSignInAuthentication =
          //changes
      await googleSignInAccount!.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
      await _auth.signInWithCredential(authCredential);
      final User? user = userCredential.user;
      if(user !=null)
        {
          UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              city: ' ',
              userDeviceToken: deviceTokenController.Token.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),);

          await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .set(userModel.toMap());
EasyLoading.dismiss();
          Get.offAll(()=>MainScreen());
        }
        }
    }catch (e)
    {
      EasyLoading.dismiss();
      print("Error $e");
    }
  }



}