import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_extensions/magic_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/bmi_helpers.dart';
import '../../../constants/constants.dart';
import '../../../constants/selection_types.dart';
import '../../../constants/target_mode.dart';
import '../../../helpers/date_x.dart';
import '../../../routes/app_pages.dart';
import '../models/weight_track_model/weight_track_model.dart';
import '../widgets/add_weight_dialog.dart';
import '../widgets/edit_user_dialog.dart';
import '../widgets/log_tile.dart';

class HomeController extends GetxController {
  final db = FirebaseFirestore.instance;
  String get userDbLabel => 'users';
  String get weightTrackLabel => 'weightTrack';
  final userWeights = <WeightEntry>[].obs;
  final isDataLoading = true.obs;
  final isAddLoading = false.obs;
  final selectedDate = DateTime.now().normalizedDate.obs;
  final selectionType = SelectionTypes.weekly.obs;

  final graphList = <WeightEntry>[].obs;

  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
    checkUser();
    selectedDate.listen((p0) {
      isDataLoading.value = true;
      if (null == user.value?.firstLogDate) {
        selectedDate.value = DateTime.now().normalizedDate;
      }

      if (selectedDate.value.normalizedDate.isAfter(
        DateTime.now().normalizedDate,
      )) {
        selectedDate.value = DateTime.now().normalizedDate;
      }

      if (selectedDate.value.normalizedDate.isBefore(
        (user.value?.firstLogDate ?? DateTime.now()).normalizedDate,
      )) {
        selectedDate.value =
            (user.value?.firstLogDate ?? DateTime.now()).normalizedDate;
      }
    });

    debounce(
      selectedDate,
      (callback) {
        addDataToGraph();
      },
      time: 200.milliseconds,
      onError: () {},
    );

    selectionType.listen((p0) {
      addDataToGraph();
    });
    super.onInit();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void onHealth() {
    launchUrl(Uri.parse('https://fitness.rsin.space/'));
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
    ).then((value) async {
      if (value == null || value.weight == null) {
        isAddLoading.value = false;
        return;
      }

      final logDate = value.date.normalizedDate;
      final weight = value.weight!;

      await userDoc
          .doc(logDate.format(format: appDateFormat))
          .set(value.toJson());

      final previousUser = user.value!;

      // Fallback to current weight for initial min/max
      final maxWt = max(previousUser.maxWeight ?? weight, weight);
      final minWt = min(previousUser.minWeight ?? weight, weight);

      // Compare new entry with existing oldest date
      final existingOldestDate =
          previousUser.lastWeightDate?.normalizedDate ?? logDate;
      final isOlderLog =
          logDate.normalizedDate.isAtSameMomentAs(now.normalizedDate)
              ? true
              : logDate.isBefore(existingOldestDate);

      final updatedFirstLogDate = [
        logDate,
        (previousUser.firstLogDate ?? logDate).normalizedDate,
        now.normalizedDate,
      ].reduce((a, b) => a.isBefore(b) ? a : b);

      user.value = previousUser.copyWith(
        maxWeight: maxWt,
        minWeight: minWt,
        currentWeight:
            isOlderLog ? weight : previousUser.currentWeight ?? weight,
        currentBMI:
            isOlderLog
                ? calculateBMI(h: previousUser.height, w: weight)
                : previousUser.currentBMI ??
                    calculateBMI(h: previousUser.height, w: weight),
        lastWeightDate: isOlderLog ? logDate : previousUser.lastWeightDate,
        firstLogDate: updatedFirstLogDate,
      );

      await FirebaseFirestore.instance
          .collection(userDbLabel)
          .doc(email)
          .set(user.value!.toJson());

      getData();
      isAddLoading.value = false;
    });
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
      getData();
    });
  }

  void getData() async {
    userWeights.clear();

    final entries =
        await FirebaseFirestore.instance
            .collection(userDbLabel)
            .doc(user.value?.email)
            .collection(weightTrackLabel)
            .get();

    for (var element in entries.docs) {
      userWeights.add(WeightEntry.fromJson(element.data()));
    }
    userWeights.sort((a, b) => a.date.compareTo(b.date));
    addDataToGraph();
  }

  List<WeightEntry> weekly(String message) {
    final today = selectedDate.value.normalizedDate;
    final sevenDayBack = today.subtract(7.days);

    final List<WeightEntry> data = [
      ...userWeights.where(
        (element) =>
            element.date.isAfter(sevenDayBack) && !element.date.isAfter(today),
      ),
    ];
    graphList.addAll(data);
    return data;
  }

  List<WeightEntry> monthly(String _) {
    final today = selectedDate.value.normalizedDate;
    final List<WeightEntry> data = [
      ...userWeights.where(
        (element) =>
            (element.date.month == today.month) &&
            (element.date.year == today.year),
      ),
    ];
    graphList.addAll(data);
    return data;
  }

  List<WeightEntry> yearly(_) {
    final today = selectedDate.value;

    final List<WeightEntry> data = [
      ...userWeights.where((element) => element.date.year == today.year),
    ];
    graphList.addAll(data);
    return data;
  }

  List<WeightEntry> yearlyAverage(_) {
    final Map<DateTime, List<double>> monthlyWeights = {};

    for (var entry in userWeights) {
      int month = entry.date.month;
      int year = entry.date.year;
      final key = DateTime(year, month);
      monthlyWeights.putIfAbsent(key, () => []);
      if (entry.weight != null) {
        monthlyWeights[key]!.add(entry.weight!);
      }
    }

    final data =
        monthlyWeights
            .map((date, weights) {
              final average = weights.reduce((a, b) => a + b) / weights.length;

              return MapEntry(
                date,
                WeightEntry(
                  timestamp: date.toIso8601String(),
                  weight: average,
                  notes: '',
                  date: date,
                ),
              );
            })
            .values
            .toList();
    graphList.addAll(
      data.where((element) => element.date.year == selectedDate.value.year),
    );
    return data;
  }

  List<WeightEntry> monthlyAverage(_) {
    final selectedMonth = selectedDate.value;
    final Map<int, List<double>> weeklyWeights = {};

    for (var entry in userWeights) {
      if (entry.date.year == selectedMonth.year &&
          entry.date.month == selectedMonth.month) {
        final week = ((entry.date.day - 1) ~/ 7) + 1;
        weeklyWeights.putIfAbsent(week, () => []);
        if (entry.weight != null) {
          weeklyWeights[week]!.add(entry.weight!);
        }
      }
    }

    final data =
        weeklyWeights.entries.map((entry) {
          final average =
              entry.value.reduce((a, b) => a + b) / entry.value.length;
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
            date: date,
          );
        }).toList();

    graphList.addAll(data);
    return data;
  }

  List<WeightEntry> all(_) {
    graphList.addAll(userWeights);
    return userWeights;
  }

  void increaseDate() {
    final sD = selectedDate.value;
    selectedDate.value = switch (selectionType.value) {
      SelectionTypes.weekly => sD.add(7.days),
      SelectionTypes.monthly => DateTime(sD.year, sD.month + 1),
      SelectionTypes.yearly => DateTime(sD.year + 1),
      SelectionTypes.monthlyAverage => DateTime(sD.year, sD.month + 1),
      SelectionTypes.yearlyAverage => DateTime(sD.year + 1),
      SelectionTypes.all => sD,
    };
  }

  void reduceDate() {
    final sD = selectedDate.value;
    selectedDate.value = switch (selectionType.value) {
      SelectionTypes.weekly => sD.subtract(7.days),
      SelectionTypes.monthly => DateTime(sD.year, sD.month - 1),
      SelectionTypes.yearly => DateTime(sD.year - 1),
      SelectionTypes.monthlyAverage => DateTime(sD.year, sD.month - 1),
      SelectionTypes.yearlyAverage => DateTime(sD.year - 1),
      SelectionTypes.all => sD,
    };
  }

  Future<void> addDataToGraph() async {
    graphList.clear();
    switch (selectionType.value) {
      case SelectionTypes.weekly:
        await compute(weekly, 'message');
        break;

      case SelectionTypes.monthly:
        await compute(monthly, 'message');
        break;

      case SelectionTypes.yearly:
        await compute(yearly, 'message');
        break;

      case SelectionTypes.monthlyAverage:
        await compute(monthlyAverage, 'message');
        break;

      case SelectionTypes.yearlyAverage:
        await compute(yearlyAverage, 'message');
        break;

      case SelectionTypes.all:
        compute(all, 'message');
    }
    isDataLoading.value = false;
  }

  double? get initialWeight => user.value?.initialWeight;

  double getBMI(double? wt) {
    return calculateBMI(h: user.value?.height, w: wt);
  }

  BmiCategory getBMICat(double? wt) {
    return getBmiCategory(getBMI(wt));
  }

  Color getBmiColor(double? wt) {
    return getBmiCategoryColor(getBMICat(wt));
  }

  String getBmiLab(double? wt) {
    return getBmiCategoryLabel(getBmiCategory(getBMI(wt)));
  }

  double? getJourneyDiff() {
    if (null == user.value?.targetMode ||
        null == user.value?.initialWeight ||
        null == user.value?.currentWeight) {
      return null;
    }

    return switch (user.value?.targetMode) {
      TargetMode.loss =>
        (user.value?.initialWeight ?? 0) - (user.value?.currentWeight ?? 0),

      TargetMode.gain =>
        (user.value?.currentWeight ?? 0) - (user.value?.initialWeight ?? 0),

      null => null,
    };
  }

  double? getGoalDiff() {
    if (null == user.value?.targetMode ||
        null == user.value?.initialWeight ||
        null == user.value?.currentWeight) {
      return null;
    }

    return ((user.value?.initialWeight ?? 0) - (user.value?.targetWeight ?? 0));
  }

  double? getProgressValue() {
    final journey = getJourneyDiff();
    final goal = getGoalDiff();

    if (journey == null || goal == null || goal == 0) return null;

    return journey.abs() / goal;
  }

  void onDeleteItem(WeightEntry item) async {
    final confirmation = await showDialog(
      context: Get.context!,
      builder:
          (context) => AlertDialog(
            title: Text('Are you sure you want to delete this entry'),
            content: LogTile(item: item, showActions: false),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('No'),
              ),
            ],
          ),
    );
    if (true != confirmation) return;
    isAddLoading.value = true;
    isDataLoading.value = true;
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null || user.value == null) {
      logout();
      return;
    }

    final userDoc = FirebaseFirestore.instance
        .collection(userDbLabel)
        .doc(email)
        .collection(weightTrackLabel);

    userDoc.doc(item.date.format(format: appDateFormat)).delete();
    getData();
    isAddLoading.value = false;
    isDataLoading.value = false;
  }

  void onEditItem(WeightEntry item) async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null || user.value == null) {
      logout();
      return;
    }

    final userDoc = FirebaseFirestore.instance
        .collection(userDbLabel)
        .doc(email)
        .collection(weightTrackLabel);

    await Get.dialog<WeightEntry>(
      AddWeightDialog(
        height: user.value!.height,
        weightEntry: item,
        allowDateChange: false,
      ),
    ).then((value) async {
      final now = DateTime.now().normalizedDate;
      if (value == null || value.weight == null) {
        isAddLoading.value = false;
        return;
      }

      final logDate = value.date.normalizedDate;
      final weight = value.weight!;

      await userDoc
          .doc(logDate.format(format: appDateFormat))
          .set(value.toJson());

      final previousUser = user.value!;

      // Fallback to current weight for initial min/max
      final maxWt = max(previousUser.maxWeight ?? weight, weight);
      final minWt = min(previousUser.minWeight ?? weight, weight);

      // Compare new entry with existing oldest date
      final existingOldestDate =
          previousUser.lastWeightDate?.normalizedDate ?? logDate;
      final isOlderLog =
          logDate.normalizedDate.isAtSameMomentAs(now.normalizedDate)
              ? true
              : logDate.isBefore(existingOldestDate);

      final updatedFirstLogDate = [
        logDate,
        (previousUser.firstLogDate ?? logDate).normalizedDate,
        now.normalizedDate,
      ].reduce((a, b) => a.isBefore(b) ? a : b);

      user.value = previousUser.copyWith(
        maxWeight: maxWt,
        minWeight: minWt,
        currentWeight:
            isOlderLog ? weight : previousUser.currentWeight ?? weight,
        currentBMI:
            isOlderLog
                ? calculateBMI(h: previousUser.height, w: weight)
                : previousUser.currentBMI ??
                    calculateBMI(h: previousUser.height, w: weight),
        lastWeightDate: isOlderLog ? logDate : previousUser.lastWeightDate,
        firstLogDate: updatedFirstLogDate,
      );

      await FirebaseFirestore.instance
          .collection(userDbLabel)
          .doc(email)
          .set(user.value!.toJson());

      getData();
      isAddLoading.value = false;
    });
  }
}
