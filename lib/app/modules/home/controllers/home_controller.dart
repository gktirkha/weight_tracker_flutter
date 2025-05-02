import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../routes/app_pages.dart';
import '../constants/bmi_helpers.dart';
import '../constants/constants.dart';
import '../models/weight_track_model/weight_track_model.dart';
import '../widgets/add_weight_dialog.dart';
import '../widgets/edit_user_dialog.dart';

class HomeController extends GetxController {
  final db = FirebaseFirestore.instance;
  String get userDbLabel => 'users';
  String get weightTrackLabel => 'weightTrack';

  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
    checkUser();
    super.onInit();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  final isAddLoading = false.obs;
  Future<void> addData() async {
    isAddLoading.value = true;
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null || user.value == null) {
      logout();
      return;
    }
    final now = DateTime.now();
    final userDoc = FirebaseFirestore.instance
        .collection(userDbLabel)
        .doc(email)
        .collection(weightTrackLabel);

    final todaysLog =
        await userDoc.doc(now.format(format: appDateFormat)).get();

    Get.dialog<WeightEntry>(
      AddWeightDialog(
        height: user.value!.height,
        weightEntry:
            todaysLog.exists ? WeightEntry.fromJson(todaysLog.data()!) : null,
      ),
    ).then((value) {
      if (value == null) return;
      userDoc.doc(value.date).set(value.toJson());
      final maxWt = max((user.value?.maxWeight ?? 0), (value.weight ?? 0));
      final minWt = min((user.value?.minWeight ?? 500), (value.weight ?? 500));
      user.value = user.value?.copyWith(maxWeight: minWt, minWeight: maxWt);
      if (user.value != null) {
        FirebaseFirestore.instance
            .collection(userDbLabel)
            .doc(email)
            .set(user.value!.toJson());
      }
    });
    isAddLoading.value = false;
  }

  final user = Rxn<WeightTrackUserModel>();

  Future<void> checkUser() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      logout();
      return;
    }
    final userData = FirebaseFirestore.instance
        .collection(userDbLabel)
        .doc(email);
    final userDoc = await userData.get();
    if (userDoc.exists) {
      user.value = WeightTrackUserModel.fromJson(userDoc.data()!);
    } else {
      onProfileEdit();
    }
  }

  void onProfileEdit() {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      logout();
      return;
    }
    Get.dialog(
      EditUserDialog(user: user.value, email: email),
      barrierDismissible: user.value != null,
    ).then((value) {
      if (value == null) return;
      FirebaseFirestore.instance
          .collection(userDbLabel)
          .doc(email)
          .set(value.toJson());
      user.value = value;
    });
  }

  final dummy = <WeightEntry>[
    WeightEntry(
      date: '01-Oct-2023',
      weight: 45,
      timestamp: DateTime.now().toString(),
      notes: 'Severely underweight',
      bmi: 15,
      bmiCategory: getBmiCategory(15),
    ),
    WeightEntry(
      date: '02-Oct-2023',
      weight: 46,
      timestamp: DateTime.now().toString(),
      notes: 'Moderately underweight',
      bmi: 16.5,
      bmiCategory: getBmiCategory(16.5),
    ),
    WeightEntry(
      date: '03-Oct-2023',
      weight: 47,
      timestamp: DateTime.now().toString(),
      notes: 'Mildly underweight',
      bmi: 18,
      bmiCategory: getBmiCategory(18),
    ),
    WeightEntry(
      date: '04-Oct-2023',
      weight: 65,
      timestamp: DateTime.now().toString(),
      notes: 'Normal',
      bmi: 22,
      bmiCategory: getBmiCategory(22),
    ),
    WeightEntry(
      date: '05-Oct-2023',
      weight: 75,
      timestamp: DateTime.now().toString(),
      notes: 'Overweight',
      bmi: 27,
      bmiCategory: getBmiCategory(27),
    ),
    WeightEntry(
      date: '06-Oct-2023',
      weight: 85,
      timestamp: DateTime.now().toString(),
      notes: 'Obese Class I',
      bmi: 32,
      bmiCategory: getBmiCategory(32),
    ),
    WeightEntry(
      date: '07-Oct-2023',
      weight: 95,
      timestamp: DateTime.now().toString(),
      notes: 'Obese Class II',
      bmi: 37,
      bmiCategory: getBmiCategory(37),
    ),
    WeightEntry(
      date: '08-Oct-2023',
      weight: 105,
      timestamp: DateTime.now().toString(),
      notes: 'Obese Class III',
      bmi: 45,
      bmiCategory: getBmiCategory(45),
    ),
  ];
}
