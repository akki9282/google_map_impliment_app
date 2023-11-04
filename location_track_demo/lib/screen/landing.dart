import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_track_demo/screen/map_screen.dart';

import 'home_screen.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _landing();
}

class _landing extends State<Landing> {
  RxInt _homeScreenIndex = 0.obs;
  List<Widget> screen = [Home(), LocationMap()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[200],
        body: SafeArea(
          child: Obx(
            () => screen[_homeScreenIndex.value],
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'map'),
            ],
            currentIndex: _homeScreenIndex.value,
            selectedItemColor: Colors.amber[800],
            onTap: (value) {
              _homeScreenIndex.value = value;
            },
          ),
        ));
  }
}
