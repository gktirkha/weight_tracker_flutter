import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  void logout() {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
