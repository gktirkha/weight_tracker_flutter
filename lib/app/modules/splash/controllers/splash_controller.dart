import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.offAll(Routes.LOGIN);
      } else {
        Get.offAll(Routes.HOME);
      }
    });
  }
}
