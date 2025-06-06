import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> Banners = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    GetBanner();
  }

  Future<void> GetBanner() async {
    try {
      QuerySnapshot BannerQuerySnapShot = await FirebaseFirestore.instance
          .collection('banners')
          .get();

      if (BannerQuerySnapShot.docs.isNotEmpty) {
        Banners.value = BannerQuerySnapShot.docs
            .map((docs) => docs['imgUrls'] as String)
            .toList();
      }
      else {
        print("No banners found in Firestore.");
      }
    } catch (e) {
      print("Error: $e");
    }
    ;
  }
}
