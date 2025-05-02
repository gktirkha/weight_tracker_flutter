import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'weight_track_model.dart';

extension WeightTrackUserModelX on WeightTrackUserModel {
  bool get isValid {
    if (email.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Email cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (height <= 0) {
      Get.snackbar(
        'Error',
        'Height should be greater than 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (name == null || name!.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (initialWeight == null || initialWeight! <= 0) {
      Get.snackbar(
        'Error',
        'Initial weight should be greater than 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (targetWeight == null || targetWeight! <= 0) {
      Get.snackbar(
        'Error',
        'Target weight should be greater than 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
