import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/target_mode.dart';
import '../controllers/home_controller.dart';
import '../detail_tile.dart';

class GoalGraphWidget extends GetView<HomeController> {
  const GoalGraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SizedBox.square(
            dimension: 200,
            child: Transform.flip(
              flipX: (controller.getJourneyDiff() ?? 0).isNegative,
              child: CircularProgressIndicator(
                strokeWidth: 16,
                value: controller.getProgressValue()?.abs(),
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  (controller.getJourneyDiff() ?? 0).isNegative
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
          ),
          64.height(),
          DetailTile(
            label: 'Goal',
            value:
                '${controller.user.value?.targetMode == TargetMode.gain ? "Gain" : "Loose"} ${(controller.getGoalDiff() ?? 0).abs().toPrecision(2)}kg Wight',
          ),
          DetailTile(
            label: 'Journey',
            value:
                '${controller.getJourneyDiff()?.toPrecision(2) ?? 0}kg (${(controller.getJourneyDiff() ?? 0).isNegative ? "Wrong" : "Correct"} Direction)',
          ),
        ],
      ),
    );
  }
}
