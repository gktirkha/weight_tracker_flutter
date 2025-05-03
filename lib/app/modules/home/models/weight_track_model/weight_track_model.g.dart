// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightTrackUserModel _$WeightTrackUserModelFromJson(
  Map<String, dynamic> json,
) => _WeightTrackUserModel(
  email: json['email'] as String,
  height: (json['height'] as num).toDouble(),
  name: json['name'] as String?,
  initialWeight: (json['initialWeight'] as num?)?.toDouble(),
  targetWeight: (json['targetWeight'] as num?)?.toDouble(),
  maxWeight: (json['maxWeight'] as num?)?.toDouble(),
  minWeight: (json['minWeight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WeightTrackUserModelToJson(
  _WeightTrackUserModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'height': instance.height,
  'name': instance.name,
  'initialWeight': instance.initialWeight,
  'targetWeight': instance.targetWeight,
  'maxWeight': instance.maxWeight,
  'minWeight': instance.minWeight,
};

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
  timestamp: json['timestamp'] as String,
  weight: (json['weight'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  bmi: (json['bmi'] as num?)?.toDouble(),
  bmiCategory: $enumDecodeNullable(_$BmiCategoryEnumMap, json['bmiCategory']),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'weight': instance.weight,
      'notes': instance.notes,
      'bmi': instance.bmi,
      'bmiCategory': _$BmiCategoryEnumMap[instance.bmiCategory],
      'date': instance.date.toIso8601String(),
    };

const _$BmiCategoryEnumMap = {
  BmiCategory.severelyUnderweight: 'severelyUnderweight',
  BmiCategory.moderatelyUnderweight: 'moderatelyUnderweight',
  BmiCategory.mildlyUnderweight: 'mildlyUnderweight',
  BmiCategory.normal: 'normal',
  BmiCategory.overweight: 'overweight',
  BmiCategory.obeseClass1: 'obeseClass1',
  BmiCategory.obeseClass2: 'obeseClass2',
  BmiCategory.obeseClass3: 'obeseClass3',
};
