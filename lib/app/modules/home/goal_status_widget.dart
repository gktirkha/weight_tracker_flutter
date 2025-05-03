import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../constants/target_mode.dart';
import 'controllers/home_controller.dart';
import 'detail_tile.dart';

class GoalStatusWidget extends GetView<HomeController> {
  const GoalStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Stats', style: TextStyle(fontSize: 24))],
          ),
          16.height(),
          DetailTile(
            label: 'Current Weight',
            value:
                controller.user.value?.currentWeight == null
                    ? 'Please Log Weight'
                    : '${controller.user.value?.currentWeight}kg',
          ),
          DetailTile(
            label: 'Target Weight',
            value:
                controller.user.value?.targetWeight == null
                    ? 'Please Set Target Weight'
                    : '${controller.user.value?.currentWeight}kg',
          ),
          DetailTile(
            label: 'Goal Mode',
            value:
                controller.user.value?.targetMode == null
                    ? 'Please Set Target Mode'
                    : getTargetModeDisplayLabel(
                      controller.user.value!.targetMode!,
                    ),
          ),
          DetailTile(
            label: 'Current BMI',
            value:
                controller.user.value?.currentBMI ?? 'Please Log some weight',
          ),
          DetailTile(
            label: 'Current BMI Category',
            value: controller.getBmiLab(controller.user.value?.currentWeight),
          ),
          DetailTile(
            label: 'Your Height',
            value:
                controller.user.value?.height == null
                    ? 'Please Set Height'
                    : '${controller.user.value?.height}cm',
          ),
        ],
      ),
    );
  }
}
