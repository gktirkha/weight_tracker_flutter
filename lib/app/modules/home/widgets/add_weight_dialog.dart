import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/bmi_helpers.dart';
import '../../../constants/constants.dart';
import '../../../helpers/date_x.dart';
import '../models/weight_track_model/weight_track_model.dart';

class AddWeightDialog extends StatelessWidget {
  AddWeightDialog({super.key, required this.height, this.weightEntry});
  late final TextEditingController weightController = TextEditingController(
    text: weightEntry?.weight.toString(),
  );
  late final TextEditingController notesController = TextEditingController(
    text: weightEntry?.notes,
  );
  late final dateNotifier = ValueNotifier(weightEntry?.date ?? DateTime.now());
  final double height;
  final WeightEntry? weightEntry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 32,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(360.days),
                    lastDate: DateTime.now(),
                    initialDate: dateNotifier.value,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  ).then((value) {
                    if (value != null) {
                      dateNotifier.value = value;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.maxFinite,
                  color: Colors.grey.withAlpha(plotBandAlpha),
                  child: ValueListenableBuilder(
                    valueListenable: dateNotifier,
                    builder:
                        (context, value, child) => Text(
                          value.format(format: appDateFormat),
                          style: TextStyle(fontSize: 24),
                        ),
                  ),
                ),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Wight in KG',
                  hintText: 'Please Enter Weight in KG',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
              ),

              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Notes',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(
                height: 56,
                width: Get.width / 3,
                child: ElevatedButton(
                  onPressed: () {
                    if (weightController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter weight',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    final weight = double.tryParse(weightController.text) ?? 0;
                    if (weight <= 0) {
                      Get.snackbar(
                        'Error',
                        'Please enter valid weight',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    final bmi = calculateBMI(h: height, w: weight);
                    Get.back(
                      result: WeightEntry(
                        notes: notesController.text,
                        timestamp: DateTime.now().toIso8601String(),
                        weight: double.parse(weightController.text),
                        bmiCategory: getBmiCategory(bmi),
                        date: dateNotifier.value.normalizedDate,
                      ),
                    );
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
