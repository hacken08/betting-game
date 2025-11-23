// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  int get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get start_time => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  DateTime get end_time => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_number')
  int? get max_number => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_price')
  String? get max_price => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int get created_by => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get created_at => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  int? get updated_by => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updated_at => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_by')
  int? get deleted_by => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deleted_at => throw _privateConstructorUsedError;

  /// Serializes this Game to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call(
      {int id,
      String uid,
      String name,
      @JsonKey(name: 'start_time') DateTime start_time,
      @JsonKey(name: 'end_time') DateTime end_time,
      @JsonKey(name: 'max_number') int? max_number,
      @JsonKey(name: 'max_price') String? max_price,
      @JsonKey(name: 'created_by') int created_by,
      @JsonKey(name: 'created_at') DateTime created_at,
      @JsonKey(name: 'updated_by') int? updated_by,
      @JsonKey(name: 'updated_at') DateTime? updated_at,
      @JsonKey(name: 'deleted_by') int? deleted_by,
      String status,
      @JsonKey(name: 'deleted_at') DateTime? deleted_at});
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Game
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
    Object? created_by = null,
    Object? created_at = null,
    Object? updated_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_by = freezed,
    Object? status = null,
    Object? deleted_at = freezed,
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
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated_by: freezed == updated_by
          ? _value.updated_by
          : updated_by // ignore: cast_nullable_to_non_nullable
              as int?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted_by: freezed == deleted_by
          ? _value.deleted_by
          : deleted_by // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameImplCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
          _$GameImpl value, $Res Function(_$GameImpl) then) =
      __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uid,
      String name,
      @JsonKey(name: 'start_time') DateTime start_time,
      @JsonKey(name: 'end_time') DateTime end_time,
      @JsonKey(name: 'max_number') int? max_number,
      @JsonKey(name: 'max_price') String? max_price,
      @JsonKey(name: 'created_by') int created_by,
      @JsonKey(name: 'created_at') DateTime created_at,
      @JsonKey(name: 'updated_by') int? updated_by,
      @JsonKey(name: 'updated_at') DateTime? updated_at,
      @JsonKey(name: 'deleted_by') int? deleted_by,
      String status,
      @JsonKey(name: 'deleted_at') DateTime? deleted_at});
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$GameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
      : super(_value, _then);

  /// Create a copy of Game
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
    Object? created_by = null,
    Object? created_at = null,
    Object? updated_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_by = freezed,
    Object? status = null,
    Object? deleted_at = freezed,
  }) {
    return _then(_$GameImpl(
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
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated_by: freezed == updated_by
          ? _value.updated_by
          : updated_by // ignore: cast_nullable_to_non_nullable
              as int?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted_by: freezed == deleted_by
          ? _value.deleted_by
          : deleted_by // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameImpl implements _Game {
  const _$GameImpl(
      {required this.id,
      required this.uid,
      required this.name,
      @JsonKey(name: 'start_time') required this.start_time,
      @JsonKey(name: 'end_time') required this.end_time,
      @JsonKey(name: 'max_number') this.max_number,
      @JsonKey(name: 'max_price') this.max_price,
      @JsonKey(name: 'created_by') required this.created_by,
      @JsonKey(name: 'created_at') required this.created_at,
      @JsonKey(name: 'updated_by') this.updated_by,
      @JsonKey(name: 'updated_at') this.updated_at,
      @JsonKey(name: 'deleted_by') this.deleted_by,
      required this.status,
      @JsonKey(name: 'deleted_at') this.deleted_at});

  factory _$GameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameImplFromJson(json);

  @override
  final int id;
  @override
  final String uid;
  @override
  final String name;
  @override
  @JsonKey(name: 'start_time')
  final DateTime start_time;
  @override
  @JsonKey(name: 'end_time')
  final DateTime end_time;
  @override
  @JsonKey(name: 'max_number')
  final int? max_number;
  @override
  @JsonKey(name: 'max_price')
  final String? max_price;
  @override
  @JsonKey(name: 'created_by')
  final int created_by;
  @override
  @JsonKey(name: 'created_at')
  final DateTime created_at;
  @override
  @JsonKey(name: 'updated_by')
  final int? updated_by;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updated_at;
  @override
  @JsonKey(name: 'deleted_by')
  final int? deleted_by;
  @override
  final String status;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deleted_at;

  @override
  String toString() {
    return 'Game(id: $id, uid: $uid, name: $name, start_time: $start_time, end_time: $end_time, max_number: $max_number, max_price: $max_price, created_by: $created_by, created_at: $created_at, updated_by: $updated_by, updated_at: $updated_at, deleted_by: $deleted_by, status: $status, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
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
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_by, updated_by) ||
                other.updated_by == updated_by) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.deleted_by, deleted_by) ||
                other.deleted_by == deleted_by) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uid,
      name,
      start_time,
      end_time,
      max_number,
      max_price,
      created_by,
      created_at,
      updated_by,
      updated_at,
      deleted_by,
      status,
      deleted_at);

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameImplToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  const factory _Game(
      {required final int id,
      required final String uid,
      required final String name,
      @JsonKey(name: 'start_time') required final DateTime start_time,
      @JsonKey(name: 'end_time') required final DateTime end_time,
      @JsonKey(name: 'max_number') final int? max_number,
      @JsonKey(name: 'max_price') final String? max_price,
      @JsonKey(name: 'created_by') required final int created_by,
      @JsonKey(name: 'created_at') required final DateTime created_at,
      @JsonKey(name: 'updated_by') final int? updated_by,
      @JsonKey(name: 'updated_at') final DateTime? updated_at,
      @JsonKey(name: 'deleted_by') final int? deleted_by,
      required final String status,
      @JsonKey(name: 'deleted_at') final DateTime? deleted_at}) = _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  int get id;
  @override
  String get uid;
  @override
  String get name;
  @override
  @JsonKey(name: 'start_time')
  DateTime get start_time;
  @override
  @JsonKey(name: 'end_time')
  DateTime get end_time;
  @override
  @JsonKey(name: 'max_number')
  int? get max_number;
  @override
  @JsonKey(name: 'max_price')
  String? get max_price;
  @override
  @JsonKey(name: 'created_by')
  int get created_by;
  @override
  @JsonKey(name: 'created_at')
  DateTime get created_at;
  @override
  @JsonKey(name: 'updated_by')
  int? get updated_by;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updated_at;
  @override
  @JsonKey(name: 'deleted_by')
  int? get deleted_by;
  @override
  String get status;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deleted_at;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
