import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:x_location_package/x_location_package_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage1(),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({super.key});

  @override
  State<MyHomePage1> createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  final LocationPackageController locationService =
      Get.put(LocationPackageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Location"),
        ),
        body: Center(child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Latitude: ${locationService.currentPosition?.value?.latitude}'),
              Text(
                  'Longitude: ${locationService.currentPosition?.value?.longitude}'),
              Text(
                  'Accuracy : ${locationService.currentPosition?.value?.accuracy}'),
              Text("Speed : ${locationService.currentPosition?.value?.speed}"),
              ElevatedButton(
                onPressed: () async {
                  //await locationService.updateLocation();
                  locationService.updateLocation();

                  locationService.locationTracking();
                },
                child: const Text('Update Location'),
              ),
            ],
          );
        })));
  }
}
