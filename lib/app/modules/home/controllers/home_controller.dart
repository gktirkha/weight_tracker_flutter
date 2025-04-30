import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../routes/app_pages.dart';
import '../models/weight_track_model/weight_track_model.dart';

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
    final DateTime date = DateTime.now();

    final WeightTrackUserModel user = WeightTrackUserModel(
      email: email,
      height: 170.0,
      name: 'Gautam Tirkha',
    );

    final userData = FirebaseFirestore.instance.collection('Users').doc(email);
    final userDoc = await userData.get();
    if (userDoc.exists) {}
    userData.set(jsonDecode(jsonEncode(user)));

    final WeightEntry weightEntry = WeightEntry(
      timestamp: date.toIso8601String(),
      weight: 80.0,
      notes: 'Feeling good',
      bmi: 22.5,
    );
    userData
        .collection('weightTrack')
        .doc(date.format(format: 'dd-MMM-yyyy'))
        .set(weightEntry.toJson());
  }
}
