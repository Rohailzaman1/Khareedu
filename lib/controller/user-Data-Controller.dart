import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  // Observable list to hold user data
  var userData = [].obs;

  // Method to fetch user data based on current user's UID
  Future<void> getUserDataController() async {
    try {
      final String? uId = FirebaseAuth.instance.currentUser?.uid;
      if (uId != null) {
        final QuerySnapshot querySnapshot = await _firebase
            .collection('user')
            .where('uId', isEqualTo: uId)
            .get();
        userData.value = querySnapshot.docs;
      } else {
        print('No user logged in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
