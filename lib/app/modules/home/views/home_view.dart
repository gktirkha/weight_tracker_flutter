import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.LOGIN);
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: controller.onProfileEdit,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: const Center(
        child: Text('HomeView is working', style: TextStyle(fontSize: 20)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addData,
        child: Obx(
          () =>
              controller.isAddLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.add),
        ),
      ),
    );
  }
}
