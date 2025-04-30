import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_track_model.freezed.dart';
part 'weight_track_model.g.dart';

@freezed
sealed class WeightTrackUserModel with _$WeightTrackUserModel {
  factory WeightTrackUserModel({
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'height') required double height,
    @JsonKey(name: 'name') String? name,
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
    @JsonKey(name: 'bmi') required double? bmi,
  }) = _WeightEntry;

  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);
}
