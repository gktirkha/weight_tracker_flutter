import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../../constants/bmi_helpers.dart';
import '../../../../constants/selection_types.dart';
import '../../controllers/home_controller.dart';
import 'all_weight_graph.dart';
import 'monthly_average_weight_graph.dart';
import 'monthly_weight_graph.dart';
import 'weekly_weight_graph.dart';
import 'yearly_average_weight_graph.dart';
import 'yearly_weight_graph.dart';

class GraphView extends GetView<HomeController> {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 450, maxHeight: 450),
            child: switch (controller.selectionType.value) {
              SelectionTypes.weekly => WeeklyWeightGraph(),

              SelectionTypes.monthly => MonthlyWeightGraph(),

              SelectionTypes.yearly => YearlyWeightGraph(),

              SelectionTypes.monthlyAverage => MonthlyAverageWeightGraph(),

              SelectionTypes.yearlyAverage => YearlyAverageWeightGraph(),

              SelectionTypes.all => AllWeightGraph(),
            },
          ),
          16.height(),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 16,
            spacing: 16,
            children: [
              ...BmiCategory.values.map(
                (e) => Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: getBmiCategoryColor(e),
                    ),
                    Text(getBmiCategoryLabel(e)),
                  ],
                ),
              ),
            ],
          ).marginSymmetric(horizontal: 32),
        ],
      ),
    );
  }
}
