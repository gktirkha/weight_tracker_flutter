import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final db = FirebaseFirestore.instance;

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

  Future<void> addData() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    final weightEntry = {'TimeStamp': Timestamp.now(), 'weight': 70.5};
    final DateTime date = DateTime.now();
    final userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('WeightEntries');
    userData.doc(date.format(format: 'dd-MMM-yyyy')).set(weightEntry);
  }
}
