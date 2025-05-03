import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';

import '../../../constants/bmi_helpers.dart';
import '../../../constants/constants.dart';
import '../../../constants/selection_types.dart';
import '../../../helpers/date_x.dart';
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
  final selectedDate = DateTime.now().normalizedDate.obs;
  final selectionType = SelectionTypes.weekly.obs;
  final dummy = <WeightEntry>[];

  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
    checkUser();
    setDummy();
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

  List<WeightEntry> get weekly {
    final today = selectedDate.value.normalizedDate;
    final sevenDayBack = today.subtract(7.days);

    final List<WeightEntry> data = [
      ...dummy.where(
        (element) =>
            element.date.isAfter(sevenDayBack) && !element.date.isAfter(today),
      ),
    ];

    return data;
  }

  List<WeightEntry> get monthly {
    final today = selectedDate.value.normalizedDate;
    final List<WeightEntry> data = [
      ...dummy.where((element) => element.date.month == today.month),
    ];
    return data;
  }

  List<WeightEntry> get yearly {
    final today = selectedDate.value;

    final List<WeightEntry> data = [
      ...dummy.where((element) => element.date.year == today.year),
    ];
    return data;
  }

  List<WeightEntry> get yearlyAverage {
    final Map<DateTime, List<double>> monthlyWeights = {};

    for (var entry in dummy) {
      int month = entry.date.month;
      int year = entry.date.year;
      final key = DateTime(year, month);
      monthlyWeights.putIfAbsent(key, () => []);
      if (entry.weight != null) {
        monthlyWeights[key]!.add(entry.weight!);
      }
    }

    return monthlyWeights
        .map((date, weights) {
          final average = weights.reduce((a, b) => a + b) / weights.length;
          final bmi = calculateBMI(h: user.value?.height ?? 0, w: average);
          return MapEntry(
            date,
            WeightEntry(
              timestamp: date.toIso8601String(),
              weight: average,
              notes: '',
              bmi: bmi,
              date: date,
              bmiCategory: getBmiCategory(bmi),
            ),
          );
        })
        .values
        .toList();
  }

  List<WeightEntry> get monthlyAverage {
    final selectedMonth = selectedDate.value;
    final Map<int, List<double>> weeklyWeights = {};

    for (var entry in dummy) {
      if (entry.date.year == selectedMonth.year &&
          entry.date.month == selectedMonth.month) {
        final week = ((entry.date.day - 1) ~/ 7) + 1;
        weeklyWeights.putIfAbsent(week, () => []);
        if (entry.weight != null) {
          weeklyWeights[week]!.add(entry.weight!);
        }
      }
    }

    return weeklyWeights.entries.map((entry) {
      final average = entry.value.reduce((a, b) => a + b) / entry.value.length;
      final bmi = calculateBMI(h: user.value?.height ?? 0, w: average);
      final weekStartDay = 1 + (entry.key - 1) * 7;
      final date = DateTime(
        selectedMonth.year,
        selectedMonth.month,
        weekStartDay,
      );

      return WeightEntry(
        timestamp: date.toIso8601String(),
        weight: average,
        notes: '',
        bmi: bmi,
        date: date,
        bmiCategory: getBmiCategory(bmi),
      );
    }).toList();
  }

  void increaseDate() {
    isDataLoading.value = true;
    final sD = selectedDate.value;

    selectedDate.value = switch (selectionType.value) {
      SelectionTypes.weekly => sD.add(7.days),
      SelectionTypes.monthly => DateTime(sD.year + 1),
      SelectionTypes.yearly => DateTime(sD.year + 1),
      SelectionTypes.monthlyAverage => DateTime(sD.year, sD.month + 1),
      SelectionTypes.yearlyAverage => DateTime(sD.year + 1),
      SelectionTypes.all => sD,
    };
    if (selectedDate.value.isAfter(DateTime.now().normalizedDate)) {
      selectedDate.value = DateTime.now().normalizedDate;
    }
    isDataLoading.value = false;
  }

  void reduceDate() {
    isDataLoading.value = true;
    final sD = selectedDate.value;

    selectedDate.value = switch (selectionType.value) {
      SelectionTypes.weekly => sD.subtract(7.days),
      SelectionTypes.monthly => DateTime(sD.year - 1),
      SelectionTypes.yearly => DateTime(sD.year - 1),
      SelectionTypes.monthlyAverage => DateTime(sD.year, sD.month - 1),
      SelectionTypes.yearlyAverage => DateTime(sD.year - 1),
      SelectionTypes.all => sD,
    };

    isDataLoading.value = false;
  }

  void setDummy() {
    isDataLoading.value = true;
    int i = 365;
    while (i > -1) {
      final date = DateTime.now().subtract(i.days).normalizedDate;
      final wt = Random().nextDouble() * 140;
      final bmi = calculateBMI(h: 170, w: wt);
      final entry = WeightEntry(
        timestamp: date.toIso8601String(),
        weight: Random().nextDouble() * 100,
        notes: ' ',
        bmi: bmi,
        date: date,
        bmiCategory: getBmiCategory(bmi),
      );
      dummy.add(entry);
      i--;
    }
    isDataLoading.value = false;
  }
}
