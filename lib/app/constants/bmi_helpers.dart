import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum BmiCategory {
  severelyUnderweight,
  moderatelyUnderweight,
  mildlyUnderweight,
  normal,
  overweight,
  obeseClass1,
  obeseClass2,
  obeseClass3,
}

BmiCategory getBmiCategory(double bmi) {
  if (bmi < 16) {
    return BmiCategory.severelyUnderweight;
  } else if (bmi >= 16 && bmi < 17) {
    return BmiCategory.moderatelyUnderweight;
  } else if (bmi >= 17 && bmi < 18.5) {
    return BmiCategory.mildlyUnderweight;
  } else if (bmi >= 18.5 && bmi < 25) {
    return BmiCategory.normal;
  } else if (bmi >= 25 && bmi < 30) {
    return BmiCategory.overweight;
  } else if (bmi >= 30 && bmi < 35) {
    return BmiCategory.obeseClass1;
  } else if (bmi >= 35 && bmi < 40) {
    return BmiCategory.obeseClass2;
  } else {
    return BmiCategory.obeseClass3;
  }
}

String getBmiCategoryLabel(BmiCategory category) {
  switch (category) {
    case BmiCategory.severelyUnderweight:
      return 'Severely underweight';
    case BmiCategory.moderatelyUnderweight:
      return 'Moderately underweight';
    case BmiCategory.mildlyUnderweight:
      return 'Mildly underweight';
    case BmiCategory.normal:
      return 'Normal weight';
    case BmiCategory.overweight:
      return 'Overweight';
    case BmiCategory.obeseClass1:
      return 'Obese Class I (Moderate)';
    case BmiCategory.obeseClass2:
      return 'Obese Class II (Severe)';
    case BmiCategory.obeseClass3:
      return 'Obese Class III (Very severe)';
  }
}

Color getBmiCategoryColor(BmiCategory category) {
  switch (category) {
    case BmiCategory.severelyUnderweight:
      return Colors.purple; // clearly distinct from red/orange
    case BmiCategory.moderatelyUnderweight:
      return Colors.indigo;
    case BmiCategory.mildlyUnderweight:
      return Colors.blue;
    case BmiCategory.normal:
      return Colors.green;
    case BmiCategory.overweight:
      return Colors.yellow.shade800;
    case BmiCategory.obeseClass1:
      return Colors.orange;
    case BmiCategory.obeseClass2:
      return Colors.deepOrange;
    case BmiCategory.obeseClass3:
      return Colors.red;
  }
}

double calculateBMI({required double? h, required double? w}) {
  if (null == h || null == w) return 0;
  if (h < 10 || w < 2) return 0;
  return (w / ((h / 100) * (h / 100))).toPrecision(2);
}

class WeightBmiRange {
  WeightBmiRange(this.min, this.max, this.category);

  final double min;
  final double max;
  final BmiCategory category;

  @override
  String toString() =>
      '${category.name}: ${min.toStringAsFixed(1)} - ${max.isInfinite ? "∞" : max.toStringAsFixed(1)} kg';
}

List<WeightBmiRange> getWeightWeightBmiRanges(
  double? heightCm, {
  double? userCurrentWt,
}) {
  if (heightCm == null) return [];
  if (heightCm < 30) return [];
  final heightMeters = heightCm / 100;
  final h2 = heightMeters * heightMeters;

  return [
    WeightBmiRange(0, 16 * h2, BmiCategory.severelyUnderweight),
    WeightBmiRange(16 * h2, 17 * h2, BmiCategory.moderatelyUnderweight),
    WeightBmiRange(17 * h2, 18.5 * h2, BmiCategory.mildlyUnderweight),
    WeightBmiRange(18.5 * h2, 25 * h2, BmiCategory.normal),
    WeightBmiRange(25 * h2, 30 * h2, BmiCategory.overweight),
    WeightBmiRange(30 * h2, 35 * h2, BmiCategory.obeseClass1),
    WeightBmiRange(35 * h2, 40 * h2, BmiCategory.obeseClass2),
    WeightBmiRange(
      40 * h2,
      max(userCurrentWt ?? 0, (40 * h2)) + 30,
      BmiCategory.obeseClass3,
    ),
  ];
}

int plotBandAlpha = 70;
