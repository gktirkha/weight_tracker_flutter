import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../constants/target_mode.dart';

part 'weight_track_model.freezed.dart';
part 'weight_track_model.g.dart';

@freezed
sealed class WeightTrackUserModel with _$WeightTrackUserModel {
  factory WeightTrackUserModel({
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'height') required double height,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'initialWeight') double? initialWeight,
    @JsonKey(name: 'targetWeight') double? targetWeight,
    @JsonKey(name: 'maxWeight') double? maxWeight,
    @JsonKey(name: 'minWeight') double? minWeight,
    @JsonKey(name: 'targetMode') TargetMode? targetMode,
    @JsonKey(name: 'firstLogDate') DateTime? firstLogDate,
    @JsonKey(name: 'currentWeight') double? currentWeight,
    @JsonKey(name: 'currentBMI') double? currentBMI,
  }) = _WeightTrackUserModel;

  factory WeightTrackUserModel.fromJson(Map<String, dynamic> json) =>
      _$WeightTrackUserModelFromJson(json);
}

@freezed
sealed class WeightEntry with _$WeightEntry {
  factory WeightEntry({
    @JsonKey(name: 'timestamp') required String timestamp,
    @JsonKey(name: 'weight') required double? weight,
    @JsonKey(name: 'notes') required String? notes,
    @JsonKey(name: 'date') required DateTime date,
  }) = _WeightEntry;

  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);
}
