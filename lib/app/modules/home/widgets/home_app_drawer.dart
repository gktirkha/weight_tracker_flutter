import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../controllers/home_controller.dart';

class HomeAppDrawer extends GetView<HomeController> {
  const HomeAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: min(Get.width * .5, 250),
        child: Container(
          color: Colors.blueGrey.shade900,
          child: Column(
            children: [
              32.height(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text('Edit Profile'),
                onTap: controller.onProfileEdit,
              ),

              ListTile(
                leading: const Icon(Icons.food_bank_outlined),
                title: Text('Fitness Plan'),
                onTap: controller.onHealth,
              ),
              Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text('Logout'),
                onTap: controller.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
