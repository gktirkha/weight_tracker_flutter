import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/target_mode.dart';
import 'controllers/home_controller.dart';

class GoalStatusWidget extends GetView<HomeController> {
  const GoalStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailTile(
            label: 'Current Weight',
            value: controller.user.value?.currentWeight ?? 'Please Log Weight',
          ),
          DetailTile(
            label: 'Targe Weight',
            value:
                controller.user.value?.targetWeight ??
                'Please Set Target Weight',
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
        ],
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({super.key, required this.label, required this.value});
  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(text: value?.toString()),
        ],
      ),
    );
  }
}
