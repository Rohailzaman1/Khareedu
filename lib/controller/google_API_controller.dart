import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Google_API_Controller extends GetxController
{
  Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  Rx<LatLng> initialPosition = LatLng(37.7749, -122.4194).obs;

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }
}