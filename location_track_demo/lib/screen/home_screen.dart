import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_track_demo/util/storage_helper.dart';

import 'package:x_location_package/x_location_package_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime lastWriteTime = DateTime.now();
  RxBool save = false.obs;

  final LocationPackageController locationService =
      Get.put(LocationPackageController());
  final StorageHelper readAndWriteFile = Get.put(StorageHelper());
  @override
  void initState() {
    locationService.updateLocation();
    locationService.location.onLocationChanged.listen((event) {
      locationService.currentPosition?.value = event;

      // &&(DateTime.now().difference(lastWriteTime) > Duration(seconds: 3))
      if (save.value = true) {
        lastWriteTime = DateTime.now();
        readAndWriteFile.write(
            '${locationService.currentPosition?.value?.latitude},${locationService.currentPosition?.value?.longitude}\n');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() => Center(
            child: Container(
              margin: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      'latitude: ${locationService.currentPosition?.value?.latitude}'),
                  Text(
                      'longitude: ${locationService.currentPosition?.value?.longitude}'),
                  Text(
                      'accuracy: ${locationService.currentPosition?.value?.accuracy}'),
                  Text(
                      'speed: ${locationService.currentPosition?.value?.speed}'),
                  ElevatedButton(
                    onPressed: () async {
                      save.value = true;
                    },
                    child: const Text('Start to save location'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      save.value = false;
                    },
                    child: const Text('Stop to save location'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await readAndWriteFile.deleteFileData();
                    },
                    child: const Text('Delete'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     await readAndWriteFile.read();
                  //   },
                  //   child: const Text('Read'),
                  // ),
                ],
              ),
            ),
          )),
    );
  }
}
