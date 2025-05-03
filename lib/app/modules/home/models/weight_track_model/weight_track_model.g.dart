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
  targetMode: $enumDecodeNullable(_$TargetModeEnumMap, json['targetMode']),
  firstLogDate:
      json['firstLogDate'] == null
          ? null
          : DateTime.parse(json['firstLogDate'] as String),
  currentWeight: (json['currentWeight'] as num?)?.toDouble(),
  currentBMI: (json['currentBMI'] as num?)?.toDouble(),
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
  'targetMode': _$TargetModeEnumMap[instance.targetMode],
  'firstLogDate': instance.firstLogDate?.toIso8601String(),
  'currentWeight': instance.currentWeight,
  'currentBMI': instance.currentBMI,
};

const _$TargetModeEnumMap = {TargetMode.loss: 'loss', TargetMode.gain: 'gain'};

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
  timestamp: json['timestamp'] as String,
  weight: (json['weight'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'weight': instance.weight,
      'notes': instance.notes,
      'date': instance.date.toIso8601String(),
    };
