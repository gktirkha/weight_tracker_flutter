import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/selection_types.dart';
import '../controllers/home_controller.dart';
import '../goal_status_widget.dart';
import '../widgets/goal_graph_widget.dart';
import '../widgets/graphs/graph_view.dart';
import '../widgets/home_app_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeAppDrawer(),
      appBar: AppBar(
        actions: [
          Obx(
            () => DropdownButton(
              value: controller.selectionType.value,
              items: [
                ...SelectionTypes.values.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(SelectionTypesX.label(e)),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.selectionType.value = value;
                }
              },
            ),
          ),
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      body: Center(
        child: Obx(
          () =>
              controller.isDataLoading.value
                  ? CircularProgressIndicator()
                  : CustomScrollView(
                    slivers: [
                      PinnedHeaderSliver(
                        child: Row(
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
                        ).marginSymmetric(horizontal: 16),
                      ),
                      SliverList.list(
                        children: [
                          16.height(),
                          GraphView(),
                          16.height(),
                          IntrinsicHeight(
                            child: Row(
                              spacing: 16,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: GoalStatusWidget(),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: GoalGraphWidget(),
                                  ),
                                ),
                              ],
                            ),
                          ).marginSymmetric(horizontal: 32),
                        ],
                      ),
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
