import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/constants.dart';
import '../../../routes/app_pages.dart';
import '../models/weight_track_model/weight_track_model.dart';
import '../widgets/add_weight_dialog.dart';
import '../widgets/edit_user_dialog.dart';

class HomeController extends GetxController {
  final db = FirebaseFirestore.instance;
  String get userDbLabel => 'users';
  String get weightTrackLabel => 'weightTrack';
  final userWeights = <WeightEntry>[].obs;
  final isDataLoading = true.obs;
  final isAddLoading = false.obs;

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
      userDoc.doc(value.date.format(format: appDateFormat)).set(value.toJson());
      final maxWt = max((user.value?.maxWeight ?? 0), (value.weight ?? 0));
      final minWt = min((user.value?.minWeight ?? 500), (value.weight ?? 500));
      user.value = user.value?.copyWith(maxWeight: minWt, minWeight: maxWt);
      if (user.value != null) {
        FirebaseFirestore.instance
            .collection(userDbLabel)
            .doc(email)
            .set(user.value!.toJson());
      }
      getData();
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
      getData();
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

  void getData() async {
    userWeights.clear();
    isDataLoading.value = true;
    final entries =
        await FirebaseFirestore.instance
            .collection(userDbLabel)
            .doc(user.value?.email)
            .collection(weightTrackLabel)
            .get();

    for (var element in entries.docs) {
      userWeights.add(WeightEntry.fromJson(element.data()));
    }
    isDataLoading.value = false;
  }
}
