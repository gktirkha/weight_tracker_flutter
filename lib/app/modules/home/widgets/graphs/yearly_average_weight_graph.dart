import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:magic_extensions/magic_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/bmi_helpers.dart';
import '../../controllers/home_controller.dart';
import '../../models/weight_track_model/weight_track_model.dart';

class YearlyAverageWeightGraph extends GetView<HomeController> {
  const YearlyAverageWeightGraph({super.key});

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
                color: controller.getBmiColor(entry.weight),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Date: ${entry.date}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Weight: ${entry.weight} kg'),
                  Text('BMI: ${controller.getBMI(entry.weight)}'),
                  Text('Category: ${controller.getBmiLab(entry.weight)}'),
                ],
              ),
            );
          },
        ),
        primaryXAxis: CategoryAxis(),
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

          plotBands:
              controller.user.value?.height == null
                  ? []
                  : getWeightWeightBmiRanges(controller.user.value?.height)
                      .map(
                        (e) => PlotBand(
                          start: e.min,
                          end: e.max,
                          color: getBmiCategoryColor(
                            e.category,
                          ).withAlpha(plotBandAlpha),
                          borderColor: Colors.black.withAlpha(80),
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
            dataSource: controller.graphList,
            pointColorMapper:
                (datum, index) => controller.getBmiColor(datum.weight),
            xValueMapper: (data, _) => data.date.format(format: 'MMM yyyy'),
            yValueMapper: (data, _) => data.weight,
          ),
        ],
      ),
    );
  }
}
