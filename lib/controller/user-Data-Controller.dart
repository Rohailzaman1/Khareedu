import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class UserDataController extends GetxController {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  // Method to fetch user data based on current user's UID
  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {

    final QuerySnapshot data = await _firebase.collection('users').where('uId',isEqualTo: uId).get();
          return data.docs;
  }
}
