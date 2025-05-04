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
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final user = Rxn<WeightTrackUserModel>();

  final userWeights = <WeightEntry>[].obs;
  final graphList = <WeightEntry>[].obs;

  final isDataLoading = true.obs;
  final isAddLoading = false.obs;
  final selectedDate = DateTime.now().normalizedDate.obs;
  final selectionType = SelectionTypes.weekly.obs;

  String get _userDbLabel => 'users';
  String get _weightTrackLabel => 'weightTrack';

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      if (user == null) Get.offAllNamed(Routes.LOGIN);
    });

    _setupDateListeners();
    _setupSelectionListeners();
    checkUser();
  }

  void _setupDateListeners() {
    selectedDate.listen((date) {
      isDataLoading.value = true;
      _normalizeSelectedDate();
    });

    debounce(selectedDate, (_) => addDataToGraph(), time: 200.milliseconds);
  }

  void _setupSelectionListeners() {
    selectionType.listen((_) => addDataToGraph());
  }

  void _normalizeSelectedDate() {
    final today = DateTime.now().normalizedDate;
    final firstLog = user.value?.firstLogDate?.normalizedDate ?? today;

    if (selectedDate.value.isAfter(today)) {
      selectedDate.value = today;
    } else if (selectedDate.value.isBefore(firstLog)) {
      selectedDate.value = firstLog;
    }
  }

  void logout() => _auth.signOut();

  void onHealth() => launchUrl(Uri.parse('https://fitness.rsin.space/'));

  Future<void> addData() async {
    await _handleWeightDialog(isEditing: false);
  }

  Future<void> onEditItem(WeightEntry item) async {
    await _handleWeightDialog(isEditing: true, entry: item);
  }

  Future<void> _handleWeightDialog({
    required bool isEditing,
    WeightEntry? entry,
  }) async {
    isAddLoading.value = true;
    final email = _auth.currentUser?.email;
    final currentUser = user.value;
    if (email == null || currentUser == null) return logout();

    final now = DateTime.now().normalizedDate;
    final userDoc = _getUserWeightCollection(email);
    WeightEntry? existingEntry;
    if (isEditing) {
      existingEntry = entry;
    } else {
      final doc = await userDoc.doc(now.format(format: appDateFormat)).get();
      if (doc.exists && doc.data() != null) {
        existingEntry = WeightEntry.fromJson(doc.data()!);
      }
    }

    final newEntry = await Get.dialog<WeightEntry>(
      AddWeightDialog(
        height: currentUser.height,
        weightEntry: existingEntry,
        allowDateChange: !isEditing,
      ),
    );

    if (newEntry?.weight == null) {
      isAddLoading.value = false;
      return;
    }

    final logDate = newEntry!.date.normalizedDate;
    await userDoc
        .doc(logDate.format(format: appDateFormat))
        .set(newEntry.toJson());
    await _updateUserWeightStats(newEntry);
    await _saveUser(email);
    await getData();
    isAddLoading.value = false;
  }

  Future<void> _updateUserWeightStats(WeightEntry entry) async {
    final currentUser = user.value!;
    final weight = entry.weight!;
    final now = DateTime.now().normalizedDate;

    final updatedUser = currentUser.copyWith(
      maxWeight: max(currentUser.maxWeight ?? weight, weight),
      minWeight: min(currentUser.minWeight ?? weight, weight),
      currentWeight:
          _isNewer(entry.date) ? currentUser.currentWeight ?? weight : weight,
      currentBMI:
          _isNewer(entry.date)
              ? currentUser.currentBMI ??
                  calculateBMI(h: currentUser.height, w: weight)
              : calculateBMI(h: currentUser.height, w: weight),
      lastWeightDate:
          _isNewer(entry.date)
              ? currentUser.lastWeightDate ?? entry.date
              : entry.date,
      firstLogDate: [
        entry.date,
        currentUser.firstLogDate ?? entry.date,
        now,
      ].reduce((a, b) => a.isBefore(b) ? a : b),
    );

    user.value = updatedUser;
  }

  bool _isNewer(DateTime date) =>
      date.normalizedDate.isBefore(DateTime.now().normalizedDate);

  CollectionReference<Map<String, dynamic>> _getUserWeightCollection(
    String email,
  ) => _db.collection(_userDbLabel).doc(email).collection(_weightTrackLabel);

  Future<void> _saveUser(String email) async {
    await _db.collection(_userDbLabel).doc(email).set(user.value!.toJson());
  }

  Future<void> checkUser() async {
    final email = _auth.currentUser?.email;
    if (email == null) return logout();

    final doc = await _db.collection(_userDbLabel).doc(email).get();
    if (doc.exists) {
      user.value = WeightTrackUserModel.fromJson(doc.data()!);
      getData();
    } else {
      onProfileEdit();
    }
  }

  void onProfileEdit() {
    final email = _auth.currentUser?.email;
    if (email == null) return logout();

    Get.dialog(
      EditUserDialog(user: user.value, email: email),
      barrierDismissible: user.value != null,
    ).then((value) async {
      if (value != null) {
        await _db.collection(_userDbLabel).doc(email).set(value.toJson());
        user.value = value;
        getData();
      }
    });
  }

  Future<void> getData() async {
    userWeights.clear();

    final email = user.value?.email;
    if (email == null) return;

    final entries = await _getUserWeightCollection(email).get();
    userWeights.addAll(entries.docs.map((e) => WeightEntry.fromJson(e.data())));
    userWeights.sort((a, b) => a.date.compareTo(b.date));
    addDataToGraph();
  }

  Future<void> addDataToGraph() async {
    graphList.clear();

    final Map<SelectionTypes, Function(String)> graphMethods = {
      SelectionTypes.weekly: weekly,
      SelectionTypes.monthly: monthly,
      SelectionTypes.yearly: yearly,
      SelectionTypes.monthlyAverage: monthlyAverage,
      SelectionTypes.yearlyAverage: yearlyAverage,
      SelectionTypes.all: all,
    };

    await compute(graphMethods[selectionType.value]!, 'message');
    isDataLoading.value = false;
  }

  List<WeightEntry> weekly(String _) {
    final start = selectedDate.value.subtract(7.days);
    final end = selectedDate.value;
    final data =
        userWeights
            .where((e) => e.date.isAfter(start) && !e.date.isAfter(end))
            .toList();
    graphList.addAll(data);
    return data;
  }

  List<WeightEntry> monthly(String _) =>
      _filterBy((d, t) => d.month == t.month && d.year == t.year);

  List<WeightEntry> yearly(String _) => _filterBy((d, t) => d.year == t.year);

  List<WeightEntry> all(String _) {
    graphList.addAll(userWeights);
    return userWeights;
  }

  List<WeightEntry> _filterBy(bool Function(DateTime, DateTime) test) {
    final today = selectedDate.value;
    final data = userWeights.where((e) => test(e.date, today)).toList();
    graphList.addAll(data);
    return data;
  }

  List<WeightEntry> monthlyAverage(String _) =>
      _averageGroupedBy((e) => ((e.date.day - 1) ~/ 7) + 1, 'month');

  List<WeightEntry> yearlyAverage(String _) =>
      _averageGroupedBy((e) => DateTime(e.date.year, e.date.month), 'year');

  List<WeightEntry> _averageGroupedBy<T>(
    T Function(WeightEntry) groupFn,
    String mode,
  ) {
    final Map<T, List<double>> grouped = {};

    for (var entry in userWeights) {
      if (entry.weight == null) continue;
      final key = groupFn(entry);
      grouped.putIfAbsent(key, () => []).add(entry.weight!);
    }

    final data =
        grouped.entries.map((e) {
          final avg = e.value.reduce((a, b) => a + b) / e.value.length;
          final date =
              mode == 'month'
                  ? DateTime(
                    selectedDate.value.year,
                    selectedDate.value.month,
                    1 + ((e.key as int) - 1) * 7,
                  )
                  : e.key as DateTime;

          return WeightEntry(
            timestamp: date.toIso8601String(),
            weight: avg,
            date: date,
            notes: '',
          );
        }).toList();

    graphList.addAll(data);
    return data;
  }

  void increaseDate() => _changeDate(forward: true);

  void reduceDate() => _changeDate(forward: false);

  void _changeDate({required bool forward}) {
    final date = selectedDate.value;
    final factor = forward ? 1 : -1;

    selectedDate.value = switch (selectionType.value) {
      SelectionTypes.weekly => date.add(Duration(days: 7 * factor)),
      SelectionTypes.monthly => DateTime(date.year, date.month + factor),
      SelectionTypes.yearly => DateTime(date.year + factor),
      SelectionTypes.monthlyAverage => DateTime(date.year, date.month + factor),
      SelectionTypes.yearlyAverage => DateTime(date.year + factor),
      SelectionTypes.all => date,
    };
  }

  double? get initialWeight => user.value?.initialWeight;

  double getBMI(double? weight) =>
      calculateBMI(h: user.value?.height, w: weight);

  BmiCategory getBMICat(double? weight) => getBmiCategory(getBMI(weight));

  Color getBmiColor(double? weight) => getBmiCategoryColor(getBMICat(weight));

  String getBmiLab(double? weight) => getBmiCategoryLabel(getBMICat(weight));

  double? getJourneyDiff() {
    final u = user.value;
    if (u == null ||
        u.targetMode == null ||
        u.initialWeight == null ||
        u.currentWeight == null) {
      return null;
    }

    return switch (u.targetMode) {
      TargetMode.loss => u.initialWeight! - u.currentWeight!,
      TargetMode.gain => u.currentWeight! - u.initialWeight!,
      null => null,
    };
  }

  double? getGoalDiff() {
    final u = user.value;
    if (u == null || u.initialWeight == null || u.targetWeight == null) {
      return null;
    }
    return (u.initialWeight! - u.targetWeight!).abs();
  }

  double? getProgressValue() {
    final journey = getJourneyDiff();
    final goal = getGoalDiff();
    if (journey == null || goal == null || goal == 0) return null;
    return journey.abs() / goal;
  }

  Future<void> onDeleteItem(WeightEntry item) async {
    final confirm = await showDialog<bool>(
      context: Get.context!,
      builder:
          (_) => AlertDialog(
            title: const Text('Are you sure you want to delete this entry?'),
            content: LogTile(item: item, showActions: false),
            actions: [
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: false),
                child: const Text('No'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    isAddLoading.value = true;
    isDataLoading.value = true;

    final email = _auth.currentUser?.email;
    if (email == null) return logout();

    await _getUserWeightCollection(
      email,
    ).doc(item.date.format(format: appDateFormat)).delete();
    await getData();

    isAddLoading.value = false;
    isDataLoading.value = false;
  }
}
