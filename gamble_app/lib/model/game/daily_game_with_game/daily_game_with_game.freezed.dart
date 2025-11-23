// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_game_with_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyGameWithGame _$DailyGameWithGameFromJson(Map<String, dynamic> json) {
  return _DailyGameWithGame.fromJson(json);
}

/// @nodoc
mixin _$DailyGameWithGame {
// Fields from `games` table
  int get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get start_time => throw _privateConstructorUsedError;
  DateTime get end_time => throw _privateConstructorUsedError;
  int? get max_number => throw _privateConstructorUsedError;
  String? get max_price => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;
  int get created_by => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;

  /// Serializes this DailyGameWithGame to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyGameWithGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyGameWithGameCopyWith<DailyGameWithGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyGameWithGameCopyWith<$Res> {
  factory $DailyGameWithGameCopyWith(
          DailyGameWithGame value, $Res Function(DailyGameWithGame) then) =
      _$DailyGameWithGameCopyWithImpl<$Res, DailyGameWithGame>;
  @useResult
  $Res call(
      {int id,
      String uid,
      String name,
      DateTime start_time,
      DateTime end_time,
      int? max_number,
      String? max_price,
      String? result,
      int created_by,
      Status status});
}

/// @nodoc
class _$DailyGameWithGameCopyWithImpl<$Res, $Val extends DailyGameWithGame>
    implements $DailyGameWithGameCopyWith<$Res> {
  _$DailyGameWithGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyGameWithGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? name = null,
    Object? start_time = null,
    Object? end_time = null,
    Object? max_number = freezed,
    Object? max_price = freezed,
    Object? result = freezed,
    Object? created_by = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      start_time: null == start_time
          ? _value.start_time
          : start_time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end_time: null == end_time
          ? _value.end_time
          : end_time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      max_number: freezed == max_number
          ? _value.max_number
          : max_number // ignore: cast_nullable_to_non_nullable
              as int?,
      max_price: freezed == max_price
          ? _value.max_price
          : max_price // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyGameWithGameImplCopyWith<$Res>
    implements $DailyGameWithGameCopyWith<$Res> {
  factory _$$DailyGameWithGameImplCopyWith(_$DailyGameWithGameImpl value,
          $Res Function(_$DailyGameWithGameImpl) then) =
      __$$DailyGameWithGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uid,
      String name,
      DateTime start_time,
      DateTime end_time,
      int? max_number,
      String? max_price,
      String? result,
      int created_by,
      Status status});
}

/// @nodoc
class __$$DailyGameWithGameImplCopyWithImpl<$Res>
    extends _$DailyGameWithGameCopyWithImpl<$Res, _$DailyGameWithGameImpl>
    implements _$$DailyGameWithGameImplCopyWith<$Res> {
  __$$DailyGameWithGameImplCopyWithImpl(_$DailyGameWithGameImpl _value,
      $Res Function(_$DailyGameWithGameImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyGameWithGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
    Object? name = null,
    Object? start_time = null,
    Object? end_time = null,
    Object? max_number = freezed,
    Object? max_price = freezed,
    Object? result = freezed,
    Object? created_by = null,
    Object? status = null,
  }) {
    return _then(_$DailyGameWithGameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      start_time: null == start_time
          ? _value.start_time
          : start_time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end_time: null == end_time
          ? _value.end_time
          : end_time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      max_number: freezed == max_number
          ? _value.max_number
          : max_number // ignore: cast_nullable_to_non_nullable
              as int?,
      max_price: freezed == max_price
          ? _value.max_price
          : max_price // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyGameWithGameImpl implements _DailyGameWithGame {
  const _$DailyGameWithGameImpl(
      {required this.id,
      required this.uid,
      required this.name,
      required this.start_time,
      required this.end_time,
      this.max_number,
      this.max_price,
      this.result,
      required this.created_by,
      required this.status});

  factory _$DailyGameWithGameImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyGameWithGameImplFromJson(json);

// Fields from `games` table
  @override
  final int id;
  @override
  final String uid;
  @override
  final String name;
  @override
  final DateTime start_time;
  @override
  final DateTime end_time;
  @override
  final int? max_number;
  @override
  final String? max_price;
  @override
  final String? result;
  @override
  final int created_by;
  @override
  final Status status;

  @override
  String toString() {
    return 'DailyGameWithGame(id: $id, uid: $uid, name: $name, start_time: $start_time, end_time: $end_time, max_number: $max_number, max_price: $max_price, result: $result, created_by: $created_by, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyGameWithGameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.start_time, start_time) ||
                other.start_time == start_time) &&
            (identical(other.end_time, end_time) ||
                other.end_time == end_time) &&
            (identical(other.max_number, max_number) ||
                other.max_number == max_number) &&
            (identical(other.max_price, max_price) ||
                other.max_price == max_price) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid, name, start_time,
      end_time, max_number, max_price, result, created_by, status);

  /// Create a copy of DailyGameWithGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyGameWithGameImplCopyWith<_$DailyGameWithGameImpl> get copyWith =>
      __$$DailyGameWithGameImplCopyWithImpl<_$DailyGameWithGameImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyGameWithGameImplToJson(
      this,
    );
  }
}

abstract class _DailyGameWithGame implements DailyGameWithGame {
  const factory _DailyGameWithGame(
      {required final int id,
      required final String uid,
      required final String name,
      required final DateTime start_time,
      required final DateTime end_time,
      final int? max_number,
      final String? max_price,
      final String? result,
      required final int created_by,
      required final Status status}) = _$DailyGameWithGameImpl;

  factory _DailyGameWithGame.fromJson(Map<String, dynamic> json) =
      _$DailyGameWithGameImpl.fromJson;

// Fields from `games` table
  @override
  int get id;
  @override
  String get uid;
  @override
  String get name;
  @override
  DateTime get start_time;
  @override
  DateTime get end_time;
  @override
  int? get max_number;
  @override
  String? get max_price;
  @override
  String? get result;
  @override
  int get created_by;
  @override
  Status get status;

  /// Create a copy of DailyGameWithGame
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyGameWithGameImplCopyWith<_$DailyGameWithGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
