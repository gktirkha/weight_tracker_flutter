import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/bmi_helpers.dart';
import '../../constants/constants.dart';
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
              ((controller.user.value?.initialWeight ?? 20) - 20) ~/ 10 * 10,
          title: AxisTitle(text: 'Weight (kg)'),
          plotBands:
              getWeightWeightBmiRanges(170)
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
            dataSource: controller.dummy,
            pointColorMapper:
                (datum, index) => getBmiCategoryColor(datum.bmiCategory!),
            xValueMapper:
                (data, _) => data.date!.parseDate(appDateFormat).format(),
            yValueMapper: (data, _) => data.weight,
          ),
        ],
      ),
    );
  }
}
