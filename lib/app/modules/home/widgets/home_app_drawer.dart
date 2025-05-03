import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';

import '../controllers/home_controller.dart';

class HomeAppDrawer extends GetView<HomeController> {
  const HomeAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: min(Get.width * .5, 250),
      child: Container(
        color: Colors.blueGrey.shade900,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: controller.onProfileEdit,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout'),
              onTap: controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}
