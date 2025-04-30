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
);

Map<String, dynamic> _$WeightTrackUserModelToJson(
  _WeightTrackUserModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'height': instance.height,
  'name': instance.name,
};

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
  timestamp: json['timestamp'] as String,
  weight: (json['weight'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  bmi: (json['bmi'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'weight': instance.weight,
      'notes': instance.notes,
      'bmi': instance.bmi,
    };
