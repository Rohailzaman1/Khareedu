import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khareedu/controller/google_API_controller.dart';
import 'package:khareedu/services/google_map_services.dart';


class MapView extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  final mapController = Get.put(Google_API_Controller());
  final GoogleApiService googleApiService = Get.put(GoogleApiService());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map')),
      body: Obx(() => GoogleMap(
        onMapCreated: (controller) async {
          mapController.onMapCreated(controller);
          // 👇 Get current location from the service
          final position = await googleApiService.getCurrentLocation();

          // 👇 Move camera to current location
          controller.animateCamera(CameraUpdate.newLatLng(
            LatLng(position!.latitude, position.longitude),
          ));
        },
        initialCameraPosition: CameraPosition(
          target: mapController.initialPosition.value,
          zoom: 14,
        ),
      )),
    );
  }

}
