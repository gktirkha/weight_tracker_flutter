import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/weight_track_model/weight_track_model.dart';

class EditUserDialog extends StatelessWidget {
  EditUserDialog({
    super.key,
    this.user,
    required this.email,
    this.allowDateChange = true,
  });
  final WeightTrackUserModel? user;
  late final TextEditingController nameController = TextEditingController(
    text: user?.name,
  );
  late final TextEditingController heightController = TextEditingController(
    text: user?.height.toString(),
  );
  late final TextEditingController initialWeight = TextEditingController(
    text: user?.initialWeight.toString(),
  );
  final String email;
  final bool allowDateChange;

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
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: 'Height in cm',
                  hintText: 'Enter your Height in cm',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: initialWeight,
                decoration: const InputDecoration(
                  labelText: 'Initial Weight in kg',
                  hintText: 'Enter your Initial Weight in kg',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(
                height: 56,
                width: Get.width / 3,
                child: ElevatedButton(
                  onPressed:
                      allowDateChange
                          ? () {
                            if (nameController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Name cannot be empty',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (heightController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Height cannot be empty',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            final double height =
                                double.tryParse(heightController.text) ?? 0.0;
                            if (height <= 0) {
                              Get.snackbar(
                                'Error',
                                'Height Should be greater than 0',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (initialWeight.text.trim().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Weight cannot be empty',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            final double initWeight =
                                double.tryParse(initialWeight.text) ?? 0.0;
                            if (initWeight <= 0) {
                              Get.snackbar(
                                'Error',
                                'Weight Should be greater than 0',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            Get.back(
                              result:
                                  user == null
                                      ? WeightTrackUserModel(
                                        email: email,
                                        name: nameController.text,
                                        height: height,
                                        initialWeight: initWeight,
                                      )
                                      : user?.copyWith(
                                        name: nameController.text,
                                        height: height,
                                        initialWeight: initWeight,
                                      ),
                            );
                          }
                          : null,
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
