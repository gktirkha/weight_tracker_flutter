// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeightTrackUserModel {

@JsonKey(name: 'email') String get email;@JsonKey(name: 'height') double get height;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'initialWeight') double? get initialWeight;@JsonKey(name: 'targetWeight') double? get targetWeight;@JsonKey(name: 'maxWeight') double? get maxWeight;@JsonKey(name: 'minWeight') double? get minWeight;@JsonKey(name: 'targetMode') TargetMode? get targetMode;@JsonKey(name: 'firstLogDate') DateTime? get firstLogDate;@JsonKey(name: 'currentWeight') double? get currentWeight;@JsonKey(name: 'currentBMI') double? get currentBMI;
/// Create a copy of WeightTrackUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightTrackUserModelCopyWith<WeightTrackUserModel> get copyWith => _$WeightTrackUserModelCopyWithImpl<WeightTrackUserModel>(this as WeightTrackUserModel, _$identity);

  /// Serializes this WeightTrackUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightTrackUserModel&&(identical(other.email, email) || other.email == email)&&(identical(other.height, height) || other.height == height)&&(identical(other.name, name) || other.name == name)&&(identical(other.initialWeight, initialWeight) || other.initialWeight == initialWeight)&&(identical(other.targetWeight, targetWeight) || other.targetWeight == targetWeight)&&(identical(other.maxWeight, maxWeight) || other.maxWeight == maxWeight)&&(identical(other.minWeight, minWeight) || other.minWeight == minWeight)&&(identical(other.targetMode, targetMode) || other.targetMode == targetMode)&&(identical(other.firstLogDate, firstLogDate) || other.firstLogDate == firstLogDate)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.currentBMI, currentBMI) || other.currentBMI == currentBMI));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,height,name,initialWeight,targetWeight,maxWeight,minWeight,targetMode,firstLogDate,currentWeight,currentBMI);

@override
String toString() {
  return 'WeightTrackUserModel(email: $email, height: $height, name: $name, initialWeight: $initialWeight, targetWeight: $targetWeight, maxWeight: $maxWeight, minWeight: $minWeight, targetMode: $targetMode, firstLogDate: $firstLogDate, currentWeight: $currentWeight, currentBMI: $currentBMI)';
}


}

/// @nodoc
abstract mixin class $WeightTrackUserModelCopyWith<$Res>  {
  factory $WeightTrackUserModelCopyWith(WeightTrackUserModel value, $Res Function(WeightTrackUserModel) _then) = _$WeightTrackUserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'email') String email,@JsonKey(name: 'height') double height,@JsonKey(name: 'name') String? name,@JsonKey(name: 'initialWeight') double? initialWeight,@JsonKey(name: 'targetWeight') double? targetWeight,@JsonKey(name: 'maxWeight') double? maxWeight,@JsonKey(name: 'minWeight') double? minWeight,@JsonKey(name: 'targetMode') TargetMode? targetMode,@JsonKey(name: 'firstLogDate') DateTime? firstLogDate,@JsonKey(name: 'currentWeight') double? currentWeight,@JsonKey(name: 'currentBMI') double? currentBMI
});




}
/// @nodoc
class _$WeightTrackUserModelCopyWithImpl<$Res>
    implements $WeightTrackUserModelCopyWith<$Res> {
  _$WeightTrackUserModelCopyWithImpl(this._self, this._then);

  final WeightTrackUserModel _self;
  final $Res Function(WeightTrackUserModel) _then;

/// Create a copy of WeightTrackUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? height = null,Object? name = freezed,Object? initialWeight = freezed,Object? targetWeight = freezed,Object? maxWeight = freezed,Object? minWeight = freezed,Object? targetMode = freezed,Object? firstLogDate = freezed,Object? currentWeight = freezed,Object? currentBMI = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,initialWeight: freezed == initialWeight ? _self.initialWeight : initialWeight // ignore: cast_nullable_to_non_nullable
as double?,targetWeight: freezed == targetWeight ? _self.targetWeight : targetWeight // ignore: cast_nullable_to_non_nullable
as double?,maxWeight: freezed == maxWeight ? _self.maxWeight : maxWeight // ignore: cast_nullable_to_non_nullable
as double?,minWeight: freezed == minWeight ? _self.minWeight : minWeight // ignore: cast_nullable_to_non_nullable
as double?,targetMode: freezed == targetMode ? _self.targetMode : targetMode // ignore: cast_nullable_to_non_nullable
as TargetMode?,firstLogDate: freezed == firstLogDate ? _self.firstLogDate : firstLogDate // ignore: cast_nullable_to_non_nullable
as DateTime?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,currentBMI: freezed == currentBMI ? _self.currentBMI : currentBMI // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WeightTrackUserModel implements WeightTrackUserModel {
   _WeightTrackUserModel({@JsonKey(name: 'email') required this.email, @JsonKey(name: 'height') required this.height, @JsonKey(name: 'name') this.name, @JsonKey(name: 'initialWeight') this.initialWeight, @JsonKey(name: 'targetWeight') this.targetWeight, @JsonKey(name: 'maxWeight') this.maxWeight, @JsonKey(name: 'minWeight') this.minWeight, @JsonKey(name: 'targetMode') this.targetMode, @JsonKey(name: 'firstLogDate') this.firstLogDate, @JsonKey(name: 'currentWeight') this.currentWeight, @JsonKey(name: 'currentBMI') this.currentBMI});
  factory _WeightTrackUserModel.fromJson(Map<String, dynamic> json) => _$WeightTrackUserModelFromJson(json);

@override@JsonKey(name: 'email') final  String email;
@override@JsonKey(name: 'height') final  double height;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'initialWeight') final  double? initialWeight;
@override@JsonKey(name: 'targetWeight') final  double? targetWeight;
@override@JsonKey(name: 'maxWeight') final  double? maxWeight;
@override@JsonKey(name: 'minWeight') final  double? minWeight;
@override@JsonKey(name: 'targetMode') final  TargetMode? targetMode;
@override@JsonKey(name: 'firstLogDate') final  DateTime? firstLogDate;
@override@JsonKey(name: 'currentWeight') final  double? currentWeight;
@override@JsonKey(name: 'currentBMI') final  double? currentBMI;

/// Create a copy of WeightTrackUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightTrackUserModelCopyWith<_WeightTrackUserModel> get copyWith => __$WeightTrackUserModelCopyWithImpl<_WeightTrackUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightTrackUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightTrackUserModel&&(identical(other.email, email) || other.email == email)&&(identical(other.height, height) || other.height == height)&&(identical(other.name, name) || other.name == name)&&(identical(other.initialWeight, initialWeight) || other.initialWeight == initialWeight)&&(identical(other.targetWeight, targetWeight) || other.targetWeight == targetWeight)&&(identical(other.maxWeight, maxWeight) || other.maxWeight == maxWeight)&&(identical(other.minWeight, minWeight) || other.minWeight == minWeight)&&(identical(other.targetMode, targetMode) || other.targetMode == targetMode)&&(identical(other.firstLogDate, firstLogDate) || other.firstLogDate == firstLogDate)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.currentBMI, currentBMI) || other.currentBMI == currentBMI));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,height,name,initialWeight,targetWeight,maxWeight,minWeight,targetMode,firstLogDate,currentWeight,currentBMI);

@override
String toString() {
  return 'WeightTrackUserModel(email: $email, height: $height, name: $name, initialWeight: $initialWeight, targetWeight: $targetWeight, maxWeight: $maxWeight, minWeight: $minWeight, targetMode: $targetMode, firstLogDate: $firstLogDate, currentWeight: $currentWeight, currentBMI: $currentBMI)';
}


}

/// @nodoc
abstract mixin class _$WeightTrackUserModelCopyWith<$Res> implements $WeightTrackUserModelCopyWith<$Res> {
  factory _$WeightTrackUserModelCopyWith(_WeightTrackUserModel value, $Res Function(_WeightTrackUserModel) _then) = __$WeightTrackUserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'email') String email,@JsonKey(name: 'height') double height,@JsonKey(name: 'name') String? name,@JsonKey(name: 'initialWeight') double? initialWeight,@JsonKey(name: 'targetWeight') double? targetWeight,@JsonKey(name: 'maxWeight') double? maxWeight,@JsonKey(name: 'minWeight') double? minWeight,@JsonKey(name: 'targetMode') TargetMode? targetMode,@JsonKey(name: 'firstLogDate') DateTime? firstLogDate,@JsonKey(name: 'currentWeight') double? currentWeight,@JsonKey(name: 'currentBMI') double? currentBMI
});




}
/// @nodoc
class __$WeightTrackUserModelCopyWithImpl<$Res>
    implements _$WeightTrackUserModelCopyWith<$Res> {
  __$WeightTrackUserModelCopyWithImpl(this._self, this._then);

  final _WeightTrackUserModel _self;
  final $Res Function(_WeightTrackUserModel) _then;

/// Create a copy of WeightTrackUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? height = null,Object? name = freezed,Object? initialWeight = freezed,Object? targetWeight = freezed,Object? maxWeight = freezed,Object? minWeight = freezed,Object? targetMode = freezed,Object? firstLogDate = freezed,Object? currentWeight = freezed,Object? currentBMI = freezed,}) {
  return _then(_WeightTrackUserModel(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,initialWeight: freezed == initialWeight ? _self.initialWeight : initialWeight // ignore: cast_nullable_to_non_nullable
as double?,targetWeight: freezed == targetWeight ? _self.targetWeight : targetWeight // ignore: cast_nullable_to_non_nullable
as double?,maxWeight: freezed == maxWeight ? _self.maxWeight : maxWeight // ignore: cast_nullable_to_non_nullable
as double?,minWeight: freezed == minWeight ? _self.minWeight : minWeight // ignore: cast_nullable_to_non_nullable
as double?,targetMode: freezed == targetMode ? _self.targetMode : targetMode // ignore: cast_nullable_to_non_nullable
as TargetMode?,firstLogDate: freezed == firstLogDate ? _self.firstLogDate : firstLogDate // ignore: cast_nullable_to_non_nullable
as DateTime?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,currentBMI: freezed == currentBMI ? _self.currentBMI : currentBMI // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$WeightEntry {

@JsonKey(name: 'timestamp') String get timestamp;@JsonKey(name: 'weight') double? get weight;@JsonKey(name: 'notes') String? get notes;@JsonKey(name: 'bmiCategory') BmiCategory? get bmiCategory;@JsonKey(name: 'date') DateTime get date;
/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightEntryCopyWith<WeightEntry> get copyWith => _$WeightEntryCopyWithImpl<WeightEntry>(this as WeightEntry, _$identity);

  /// Serializes this WeightEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bmiCategory, bmiCategory) || other.bmiCategory == bmiCategory)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,weight,notes,bmiCategory,date);

@override
String toString() {
  return 'WeightEntry(timestamp: $timestamp, weight: $weight, notes: $notes, bmiCategory: $bmiCategory, date: $date)';
}


}

/// @nodoc
abstract mixin class $WeightEntryCopyWith<$Res>  {
  factory $WeightEntryCopyWith(WeightEntry value, $Res Function(WeightEntry) _then) = _$WeightEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'timestamp') String timestamp,@JsonKey(name: 'weight') double? weight,@JsonKey(name: 'notes') String? notes,@JsonKey(name: 'bmiCategory') BmiCategory? bmiCategory,@JsonKey(name: 'date') DateTime date
});




}
/// @nodoc
class _$WeightEntryCopyWithImpl<$Res>
    implements $WeightEntryCopyWith<$Res> {
  _$WeightEntryCopyWithImpl(this._self, this._then);

  final WeightEntry _self;
  final $Res Function(WeightEntry) _then;

/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? weight = freezed,Object? notes = freezed,Object? bmiCategory = freezed,Object? date = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bmiCategory: freezed == bmiCategory ? _self.bmiCategory : bmiCategory // ignore: cast_nullable_to_non_nullable
as BmiCategory?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WeightEntry implements WeightEntry {
   _WeightEntry({@JsonKey(name: 'timestamp') required this.timestamp, @JsonKey(name: 'weight') required this.weight, @JsonKey(name: 'notes') required this.notes, @JsonKey(name: 'bmiCategory') this.bmiCategory, @JsonKey(name: 'date') required this.date});
  factory _WeightEntry.fromJson(Map<String, dynamic> json) => _$WeightEntryFromJson(json);

@override@JsonKey(name: 'timestamp') final  String timestamp;
@override@JsonKey(name: 'weight') final  double? weight;
@override@JsonKey(name: 'notes') final  String? notes;
@override@JsonKey(name: 'bmiCategory') final  BmiCategory? bmiCategory;
@override@JsonKey(name: 'date') final  DateTime date;

/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightEntryCopyWith<_WeightEntry> get copyWith => __$WeightEntryCopyWithImpl<_WeightEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bmiCategory, bmiCategory) || other.bmiCategory == bmiCategory)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,weight,notes,bmiCategory,date);

@override
String toString() {
  return 'WeightEntry(timestamp: $timestamp, weight: $weight, notes: $notes, bmiCategory: $bmiCategory, date: $date)';
}


}

/// @nodoc
abstract mixin class _$WeightEntryCopyWith<$Res> implements $WeightEntryCopyWith<$Res> {
  factory _$WeightEntryCopyWith(_WeightEntry value, $Res Function(_WeightEntry) _then) = __$WeightEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'timestamp') String timestamp,@JsonKey(name: 'weight') double? weight,@JsonKey(name: 'notes') String? notes,@JsonKey(name: 'bmiCategory') BmiCategory? bmiCategory,@JsonKey(name: 'date') DateTime date
});




}
/// @nodoc
class __$WeightEntryCopyWithImpl<$Res>
    implements _$WeightEntryCopyWith<$Res> {
  __$WeightEntryCopyWithImpl(this._self, this._then);

  final _WeightEntry _self;
  final $Res Function(_WeightEntry) _then;

/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? weight = freezed,Object? notes = freezed,Object? bmiCategory = freezed,Object? date = null,}) {
  return _then(_WeightEntry(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bmiCategory: freezed == bmiCategory ? _self.bmiCategory : bmiCategory // ignore: cast_nullable_to_non_nullable
as BmiCategory?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
