import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_track_demo/util/storage_helper.dart';
import 'package:x_location_package/x_location_package_controller.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMap();
}

class _LocationMap extends State<LocationMap> {
  final LocationPackageController locationService =
      Get.put(LocationPackageController());

  final StorageHelper readAndWriteFile = Get.put(StorageHelper());
  GoogleMapController? _googleMapController;

  List<LatLng> polylineCoordinates = [];
  List<String> latLng = [];

  LatLng sourceLatLng = LatLng(0, 0);
  LatLng destinationLatLng = LatLng(0, 0);
  @override
  void initState() {
    getPolyline();
    locationService.updateLocation();
    locationService.location.onLocationChanged.listen((event) {
      locationService.currentPosition?.value = event;
    });
    super.initState();
  }

  void getPolyline() async {
    latLng = await readAndWriteFile.read();

    sourceLatLng = LatLng(double.parse(latLng.first.split(',').first),
        double.parse(latLng.first.split(',').last));
    destinationLatLng = LatLng(double.parse(latLng.last.split(',').first),
        double.parse(latLng.last.split(',').last));

    if (latLng.isNotEmpty) {
      latLng.forEach((element) => polylineCoordinates.add(LatLng(
          double.parse(element.split(',').first),
          double.parse(element.split(',').last))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => GoogleMap(
          polylines: {
            Polyline(
                polylineId: PolylineId('route'),
                points: polylineCoordinates,
                width: 5,
                color: Colors.purple),
          },
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                locationService.currentPosition?.value?.latitude ?? 0.0,
                locationService.currentPosition?.value?.longitude ?? 0.0),
            zoom: 12.2,
          ),
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
          markers: {
            Marker(
              markerId: MarkerId('currentPosition'),
              position: LatLng(
                  locationService.currentPosition?.value?.latitude ?? 0.0,
                  locationService.currentPosition?.value?.longitude ?? 0.0),
            ),
            Marker(
              markerId: MarkerId('sourceId'),
              position: sourceLatLng,
            ),
            Marker(
              markerId: MarkerId('destinationId'),
              // draggable: true,
              position: sourceLatLng,
              // onDragEnd: (value) {},
            ),
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _googleMapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      locationService.currentPosition?.value?.latitude ?? 0.0,
                      locationService.currentPosition?.value?.longitude ?? 0.0),
                  zoom: 15.0),
            ),
          );
        },
        child: Icon(Icons.center_focus_strong),
      ),
    );
  }
}
