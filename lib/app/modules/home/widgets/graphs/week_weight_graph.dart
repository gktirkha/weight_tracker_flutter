import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/bmi_helpers.dart';
import '../../controllers/home_controller.dart';
import '../../models/weight_track_model/weight_track_model.dart';

class WeekWeightGraph extends GetView<HomeController> {
  const WeekWeightGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
        ),
        tooltipBehavior: TooltipBehavior(
          shadowColor: Colors.transparent,
          enable: true,
          header: '',
          builder: (data, point, series, pointIndex, seriesIndex) {
            final entry = data as WeightEntry;
            return Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: getBmiCategoryColor(data.bmiCategory!),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Date: ${entry.date}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Weight: ${entry.weight} kg'),
                  Text('BMI: ${entry.bmi?.toStringAsFixed(1)}'),
                  Text('Category: ${getBmiCategoryLabel(entry.bmiCategory!)}'),
                ],
              ),
            );
          },
        ),
        primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
        primaryYAxis: NumericAxis(
          minimum:
              controller.user.value == null
                  ? 0
                  : min(
                        getWeightWeightBmiRanges(
                              controller.user.value!.height,
                            ).first.max -
                            10,
                        (controller.user.value!.minWeight ?? 0),
                      ) ~/
                      10 *
                      10,

          maximum:
              controller.user.value == null
                  ? null
                  : max(
                        getWeightWeightBmiRanges(
                              controller.user.value!.height,
                            ).last.min +
                            10,
                        (controller.user.value!.maxWeight ?? 0),
                      ) ~/
                      10 *
                      10,
          title: AxisTitle(text: 'Weight (kg)'),
          plotBands:
              controller.user.value?.height == null
                  ? []
                  : getWeightWeightBmiRanges(170)
                      .map(
                        (e) => PlotBand(
                          start: e.min,
                          end: e.max,
                          color: getBmiCategoryColor(e.category).withAlpha(30),
                          borderColor: Colors.black.withAlpha(80),
                          text: getBmiCategoryLabel(e.category),
                        ),
                      )
                      .toList(),
          labelFormat: '{value} kg',
        ),
        series: <CartesianSeries>[
          LineSeries<WeightEntry, String>(
            markerSettings: const MarkerSettings(
              isVisible: true,
              color: Colors.white,
              borderColor: Colors.black,
              height: 16,
              width: 16,
            ),
            dataSource: controller.userWeights,
            pointColorMapper:
                (datum, index) => getBmiCategoryColor(datum.bmiCategory!),
            xValueMapper: (data, _) => data.date.format(),
            yValueMapper: (data, _) => data.weight,
          ),
        ],
      ),
    );
  }
}
