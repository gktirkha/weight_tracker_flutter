import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/weight_track_model/weight_track_model.dart';

class EditUserDialog extends StatelessWidget {
  EditUserDialog({super.key, this.user, required this.email});
  final WeightTrackUserModel? user;
  late final TextEditingController nameController = TextEditingController(
    text: user?.name,
  );
  late final TextEditingController heightController = TextEditingController(
    text: user?.height.toString(),
  );
  final String email;

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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              SizedBox(
                height: 56,
                width: Get.width / 3,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(
                      result:
                          user == null
                              ? WeightTrackUserModel(
                                email: email,
                                name: nameController.text,
                                height:
                                    double.tryParse(heightController.text) ??
                                    0.0,
                              )
                              : user?.copyWith(
                                name: nameController.text,
                                height:
                                    double.tryParse(heightController.text) ??
                                    0.0,
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
