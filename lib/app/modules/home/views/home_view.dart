import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../widgets/graphs/month_graph.dart';

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
      body: Center(
        child: Obx(
          () =>
              controller.isDataLoading.value
                  ? CircularProgressIndicator()
                  : Column(
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: controller.reduceDate,
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                          IconButton(
                            onPressed: controller.increaseDate,
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      MonthWeightGraph(),
                    ],
                  ),
        ),
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
