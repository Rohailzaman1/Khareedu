

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class DeviceTokenController extends GetxController
{
  String? Token;
  @override
  void onInit() {
    super.onInit();
    getDeviceTokenController();
  }
  Future<void> getDeviceTokenController()
  async {
    try{
      String? token = await FirebaseMessaging.instance.getToken();
      if(token!=null)
        {
         print("Token: $token");
          Token = token.toString();
          print("Token: $Token");
          update();
        }
    }catch (e)
    {
      Get.snackbar("Error", "$e", snackPosition: SnackPosition.BOTTOM);
    }
  }
}