// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyGame _$DailyGameFromJson(Map<String, dynamic> json) {
  return _DailyGame.fromJson(json);
}

/// @nodoc
mixin _$DailyGame {
  int get id => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;
  DailyGameStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_id')
  int get game_id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int get created_by => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  int? get updated_by => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get created_at => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_by')
  int? get deleted_by => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updated_at => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deleted_at => throw _privateConstructorUsedError;

  /// Serializes this DailyGame to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyGameCopyWith<DailyGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyGameCopyWith<$Res> {
  factory $DailyGameCopyWith(DailyGame value, $Res Function(DailyGame) then) =
      _$DailyGameCopyWithImpl<$Res, DailyGame>;
  @useResult
  $Res call(
      {int id,
      String? result,
      DailyGameStatus status,
      @JsonKey(name: 'game_id') int game_id,
      @JsonKey(name: 'created_by') int created_by,
      @JsonKey(name: 'updated_by') int? updated_by,
      @JsonKey(name: 'created_at') DateTime created_at,
      @JsonKey(name: 'deleted_by') int? deleted_by,
      @JsonKey(name: 'updated_at') DateTime? updated_at,
      @JsonKey(name: 'deleted_at') DateTime? deleted_at});
}

/// @nodoc
class _$DailyGameCopyWithImpl<$Res, $Val extends DailyGame>
    implements $DailyGameCopyWith<$Res> {
  _$DailyGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? result = freezed,
    Object? status = null,
    Object? game_id = null,
    Object? created_by = null,
    Object? updated_by = freezed,
    Object? created_at = null,
    Object? deleted_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DailyGameStatus,
      game_id: null == game_id
          ? _value.game_id
          : game_id // ignore: cast_nullable_to_non_nullable
              as int,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      updated_by: freezed == updated_by
          ? _value.updated_by
          : updated_by // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deleted_by: freezed == deleted_by
          ? _value.deleted_by
          : deleted_by // ignore: cast_nullable_to_non_nullable
              as int?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyGameImplCopyWith<$Res>
    implements $DailyGameCopyWith<$Res> {
  factory _$$DailyGameImplCopyWith(
          _$DailyGameImpl value, $Res Function(_$DailyGameImpl) then) =
      __$$DailyGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? result,
      DailyGameStatus status,
      @JsonKey(name: 'game_id') int game_id,
      @JsonKey(name: 'created_by') int created_by,
      @JsonKey(name: 'updated_by') int? updated_by,
      @JsonKey(name: 'created_at') DateTime created_at,
      @JsonKey(name: 'deleted_by') int? deleted_by,
      @JsonKey(name: 'updated_at') DateTime? updated_at,
      @JsonKey(name: 'deleted_at') DateTime? deleted_at});
}

/// @nodoc
class __$$DailyGameImplCopyWithImpl<$Res>
    extends _$DailyGameCopyWithImpl<$Res, _$DailyGameImpl>
    implements _$$DailyGameImplCopyWith<$Res> {
  __$$DailyGameImplCopyWithImpl(
      _$DailyGameImpl _value, $Res Function(_$DailyGameImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? result = freezed,
    Object? status = null,
    Object? game_id = null,
    Object? created_by = null,
    Object? updated_by = freezed,
    Object? created_at = null,
    Object? deleted_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_$DailyGameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DailyGameStatus,
      game_id: null == game_id
          ? _value.game_id
          : game_id // ignore: cast_nullable_to_non_nullable
              as int,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      updated_by: freezed == updated_by
          ? _value.updated_by
          : updated_by // ignore: cast_nullable_to_non_nullable
              as int?,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deleted_by: freezed == deleted_by
          ? _value.deleted_by
          : deleted_by // ignore: cast_nullable_to_non_nullable
              as int?,
      updated_at: freezed == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyGameImpl implements _DailyGame {
  const _$DailyGameImpl(
      {required this.id,
      this.result,
      required this.status,
      @JsonKey(name: 'game_id') required this.game_id,
      @JsonKey(name: 'created_by') required this.created_by,
      @JsonKey(name: 'updated_by') this.updated_by,
      @JsonKey(name: 'created_at') required this.created_at,
      @JsonKey(name: 'deleted_by') this.deleted_by,
      @JsonKey(name: 'updated_at') this.updated_at,
      @JsonKey(name: 'deleted_at') this.deleted_at});

  factory _$DailyGameImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyGameImplFromJson(json);

  @override
  final int id;
  @override
  final String? result;
  @override
  final DailyGameStatus status;
  @override
  @JsonKey(name: 'game_id')
  final int game_id;
  @override
  @JsonKey(name: 'created_by')
  final int created_by;
  @override
  @JsonKey(name: 'updated_by')
  final int? updated_by;
  @override
  @JsonKey(name: 'created_at')
  final DateTime created_at;
  @override
  @JsonKey(name: 'deleted_by')
  final int? deleted_by;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updated_at;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deleted_at;

  @override
  String toString() {
    return 'DailyGame(id: $id, result: $result, status: $status, game_id: $game_id, created_by: $created_by, updated_by: $updated_by, created_at: $created_at, deleted_by: $deleted_by, updated_at: $updated_at, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyGameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.game_id, game_id) || other.game_id == game_id) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.updated_by, updated_by) ||
                other.updated_by == updated_by) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.deleted_by, deleted_by) ||
                other.deleted_by == deleted_by) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, result, status, game_id,
      created_by, updated_by, created_at, deleted_by, updated_at, deleted_at);

  /// Create a copy of DailyGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyGameImplCopyWith<_$DailyGameImpl> get copyWith =>
      __$$DailyGameImplCopyWithImpl<_$DailyGameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyGameImplToJson(
      this,
    );
  }
}

abstract class _DailyGame implements DailyGame {
  const factory _DailyGame(
          {required final int id,
          final String? result,
          required final DailyGameStatus status,
          @JsonKey(name: 'game_id') required final int game_id,
          @JsonKey(name: 'created_by') required final int created_by,
          @JsonKey(name: 'updated_by') final int? updated_by,
          @JsonKey(name: 'created_at') required final DateTime created_at,
          @JsonKey(name: 'deleted_by') final int? deleted_by,
          @JsonKey(name: 'updated_at') final DateTime? updated_at,
          @JsonKey(name: 'deleted_at') final DateTime? deleted_at}) =
      _$DailyGameImpl;

  factory _DailyGame.fromJson(Map<String, dynamic> json) =
      _$DailyGameImpl.fromJson;

  @override
  int get id;
  @override
  String? get result;
  @override
  DailyGameStatus get status;
  @override
  @JsonKey(name: 'game_id')
  int get game_id;
  @override
  @JsonKey(name: 'created_by')
  int get created_by;
  @override
  @JsonKey(name: 'updated_by')
  int? get updated_by;
  @override
  @JsonKey(name: 'created_at')
  DateTime get created_at;
  @override
  @JsonKey(name: 'deleted_by')
  int? get deleted_by;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updated_at;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deleted_at;

  /// Create a copy of DailyGame
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyGameImplCopyWith<_$DailyGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
