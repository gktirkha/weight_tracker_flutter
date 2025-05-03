import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/target_mode.dart';
import '../models/weight_track_model/weight_track_model.dart';
import '../models/weight_track_model/weight_track_model_x.dart';

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
  late final TextEditingController initialWeightController =
      TextEditingController(text: user?.initialWeight.toString());
  late final TextEditingController targetWeightController =
      TextEditingController(text: user?.targetWeight.toString());
  final String email;
  final bool allowDateChange;
  final targetMode = ValueNotifier(TargetMode.loss);

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
                controller: initialWeightController,
                decoration: const InputDecoration(
                  labelText: 'Initial Weight in kg',
                  hintText: 'Enter your Initial Weight in kg',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                keyboardType: TextInputType.number,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 16,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: targetWeightController,
                        decoration: const InputDecoration(
                          labelText: 'Target Weight in kg',
                          hintText: 'Enter your Target Weight in kg',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: targetMode,
                        builder: (_, mode, c) {
                          return DropdownButton(
                            isExpanded: true,
                            value: mode,
                            items: [
                              DropdownMenuItem(
                                value: TargetMode.gain,
                                child: Text('Gain'),
                              ),
                              DropdownMenuItem(
                                value: TargetMode.loss,
                                child: Text('loss'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                targetMode.value = value;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 56,
                width: Get.width / 3,
                child: ElevatedButton(onPressed: onSave, child: Text('Save')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSave() {
    final parsedUser =
        user == null
            ? WeightTrackUserModel(
              email: email,
              name: nameController.text,
              height: heightController.text.magicDouble(),
              initialWeight: initialWeightController.text.magicDouble(),
              targetWeight: targetWeightController.text.magicDouble(),
              targetMode: targetMode.value,
            )
            : user!.copyWith(
              email: email,
              name: nameController.text,
              height: heightController.text.magicDouble(),
              initialWeight: initialWeightController.text.magicDouble(),
              targetWeight: targetWeightController.text.magicDouble(),
              targetMode: targetMode.value,
            );

    if (parsedUser.isValid) {
      Get.back(result: parsedUser);
    }
  }
}
