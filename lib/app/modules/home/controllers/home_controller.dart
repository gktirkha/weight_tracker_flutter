import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
    super.onInit();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}
