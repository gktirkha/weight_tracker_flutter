import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/selection_types.dart';
import '../controllers/home_controller.dart';
import '../detail_tile.dart';
import '../goal_status_widget.dart';
import '../models/weight_track_model/weight_track_model.dart';
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
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
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
                      16.height().sliverBox,
                      if (controller.graphList.isNotEmpty)
                        PinnedHeaderSliver(
                          child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Text(
                              'Logs',
                              style: TextStyle(fontSize: 24),
                            ).marginSymmetric(horizontal: 32),
                          ),
                        ),
                      16.height().sliverBox,
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        sliver: Obx(
                          () => SliverList.separated(
                            separatorBuilder:
                                (context, index) =>
                                    Divider(color: Colors.white, height: 2),
                            itemBuilder: (context, index) {
                              final item = controller.graphList[index];
                              return LogTile(item: item);
                            },
                            itemCount: controller.graphList.length,
                          ),
                        ),
                      ),
                      100.height().sliverBox,
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

class LogTile extends GetView<HomeController> {
  const LogTile({super.key, required this.item});

  final WeightEntry item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height(),
              Text(item.date.format(), style: TextStyle(fontSize: 16)),
              8.height(),
              DetailTile(
                useRow: false,
                label: 'Weight',
                value: item.weight?.toPrecision(2) ?? 'N/A',
              ),
              DetailTile(
                useRow: false,
                label: 'Note',
                value: item.notes ?? 'N/A',
              ),
              8.height(),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            controller.onDeleteItem(item);
          },
          icon: Icon(Icons.delete),
        ),
        32.width(),
        IconButton(
          onPressed: () {
            controller.onEditItem(item);
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}
