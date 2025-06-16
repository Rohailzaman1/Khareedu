import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khareedu/controller/google_API_controller.dart';


class MapView extends StatelessWidget {
  final mapController = Get.put(Google_API_Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Map')),
      body: Obx(() => GoogleMap(
        onMapCreated: mapController.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: mapController.initialPosition.value,
          zoom: 14,
        ),
      )),
    );
  }
}
