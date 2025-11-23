// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserBet _$UserBetFromJson(Map<String, dynamic> json) {
  return _UserBet.fromJson(json);
}

/// @nodoc
mixin _$UserBet {
  int get id => throw _privateConstructorUsedError;
  int get game_id => throw _privateConstructorUsedError;
  int get daily_game_id => throw _privateConstructorUsedError;
  int get user_id => throw _privateConstructorUsedError;
  GameType get game_type => throw _privateConstructorUsedError;
  String get bid_number => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  int get created_by => throw _privateConstructorUsedError;
  DateTime get created_at => throw _privateConstructorUsedError;
  DailyGame? get daily_game => throw _privateConstructorUsedError;
  Game? get game => throw _privateConstructorUsedError;
  int? get updated_by => throw _privateConstructorUsedError;
  DateTime? get updated_at => throw _privateConstructorUsedError;
  int? get deleted_by => throw _privateConstructorUsedError;
  DateTime? get deleted_at => throw _privateConstructorUsedError;

  /// Serializes this UserBet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBetCopyWith<UserBet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBetCopyWith<$Res> {
  factory $UserBetCopyWith(UserBet value, $Res Function(UserBet) then) =
      _$UserBetCopyWithImpl<$Res, UserBet>;
  @useResult
  $Res call(
      {int id,
      int game_id,
      int daily_game_id,
      int user_id,
      GameType game_type,
      String bid_number,
      Status status,
      String amount,
      int created_by,
      DateTime created_at,
      DailyGame? daily_game,
      Game? game,
      int? updated_by,
      DateTime? updated_at,
      int? deleted_by,
      DateTime? deleted_at});

  $DailyGameCopyWith<$Res>? get daily_game;
  $GameCopyWith<$Res>? get game;
}

/// @nodoc
class _$UserBetCopyWithImpl<$Res, $Val extends UserBet>
    implements $UserBetCopyWith<$Res> {
  _$UserBetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? game_id = null,
    Object? daily_game_id = null,
    Object? user_id = null,
    Object? game_type = null,
    Object? bid_number = null,
    Object? status = null,
    Object? amount = null,
    Object? created_by = null,
    Object? created_at = null,
    Object? daily_game = freezed,
    Object? game = freezed,
    Object? updated_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_by = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      game_id: null == game_id
          ? _value.game_id
          : game_id // ignore: cast_nullable_to_non_nullable
              as int,
      daily_game_id: null == daily_game_id
          ? _value.daily_game_id
          : daily_game_id // ignore: cast_nullable_to_non_nullable
              as int,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as int,
      game_type: null == game_type
          ? _value.game_type
          : game_type // ignore: cast_nullable_to_non_nullable
              as GameType,
      bid_number: null == bid_number
          ? _value.bid_number
          : bid_number // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daily_game: freezed == daily_game
          ? _value.daily_game
          : daily_game // ignore: cast_nullable_to_non_nullable
              as DailyGame?,
      game: freezed == game
          ? _value.game
          : game // ignore: cast_nullable_to_non_nullable
              as Game?,
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
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyGameCopyWith<$Res>? get daily_game {
    if (_value.daily_game == null) {
      return null;
    }

    return $DailyGameCopyWith<$Res>(_value.daily_game!, (value) {
      return _then(_value.copyWith(daily_game: value) as $Val);
    });
  }

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameCopyWith<$Res>? get game {
    if (_value.game == null) {
      return null;
    }

    return $GameCopyWith<$Res>(_value.game!, (value) {
      return _then(_value.copyWith(game: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserBetImplCopyWith<$Res> implements $UserBetCopyWith<$Res> {
  factory _$$UserBetImplCopyWith(
          _$UserBetImpl value, $Res Function(_$UserBetImpl) then) =
      __$$UserBetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int game_id,
      int daily_game_id,
      int user_id,
      GameType game_type,
      String bid_number,
      Status status,
      String amount,
      int created_by,
      DateTime created_at,
      DailyGame? daily_game,
      Game? game,
      int? updated_by,
      DateTime? updated_at,
      int? deleted_by,
      DateTime? deleted_at});

  @override
  $DailyGameCopyWith<$Res>? get daily_game;
  @override
  $GameCopyWith<$Res>? get game;
}

/// @nodoc
class __$$UserBetImplCopyWithImpl<$Res>
    extends _$UserBetCopyWithImpl<$Res, _$UserBetImpl>
    implements _$$UserBetImplCopyWith<$Res> {
  __$$UserBetImplCopyWithImpl(
      _$UserBetImpl _value, $Res Function(_$UserBetImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? game_id = null,
    Object? daily_game_id = null,
    Object? user_id = null,
    Object? game_type = null,
    Object? bid_number = null,
    Object? status = null,
    Object? amount = null,
    Object? created_by = null,
    Object? created_at = null,
    Object? daily_game = freezed,
    Object? game = freezed,
    Object? updated_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_by = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_$UserBetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      game_id: null == game_id
          ? _value.game_id
          : game_id // ignore: cast_nullable_to_non_nullable
              as int,
      daily_game_id: null == daily_game_id
          ? _value.daily_game_id
          : daily_game_id // ignore: cast_nullable_to_non_nullable
              as int,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as int,
      game_type: null == game_type
          ? _value.game_type
          : game_type // ignore: cast_nullable_to_non_nullable
              as GameType,
      bid_number: null == bid_number
          ? _value.bid_number
          : bid_number // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      created_by: null == created_by
          ? _value.created_by
          : created_by // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      daily_game: freezed == daily_game
          ? _value.daily_game
          : daily_game // ignore: cast_nullable_to_non_nullable
              as DailyGame?,
      game: freezed == game
          ? _value.game
          : game // ignore: cast_nullable_to_non_nullable
              as Game?,
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
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBetImpl implements _UserBet {
  const _$UserBetImpl(
      {required this.id,
      required this.game_id,
      required this.daily_game_id,
      required this.user_id,
      required this.game_type,
      required this.bid_number,
      required this.status,
      required this.amount,
      required this.created_by,
      required this.created_at,
      this.daily_game,
      this.game,
      this.updated_by,
      this.updated_at,
      this.deleted_by,
      this.deleted_at});

  factory _$UserBetImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBetImplFromJson(json);

  @override
  final int id;
  @override
  final int game_id;
  @override
  final int daily_game_id;
  @override
  final int user_id;
  @override
  final GameType game_type;
  @override
  final String bid_number;
  @override
  final Status status;
  @override
  final String amount;
  @override
  final int created_by;
  @override
  final DateTime created_at;
  @override
  final DailyGame? daily_game;
  @override
  final Game? game;
  @override
  final int? updated_by;
  @override
  final DateTime? updated_at;
  @override
  final int? deleted_by;
  @override
  final DateTime? deleted_at;

  @override
  String toString() {
    return 'UserBet(id: $id, game_id: $game_id, daily_game_id: $daily_game_id, user_id: $user_id, game_type: $game_type, bid_number: $bid_number, status: $status, amount: $amount, created_by: $created_by, created_at: $created_at, daily_game: $daily_game, game: $game, updated_by: $updated_by, updated_at: $updated_at, deleted_by: $deleted_by, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.game_id, game_id) || other.game_id == game_id) &&
            (identical(other.daily_game_id, daily_game_id) ||
                other.daily_game_id == daily_game_id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.game_type, game_type) ||
                other.game_type == game_type) &&
            (identical(other.bid_number, bid_number) ||
                other.bid_number == bid_number) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.daily_game, daily_game) ||
                other.daily_game == daily_game) &&
            (identical(other.game, game) || other.game == game) &&
            (identical(other.updated_by, updated_by) ||
                other.updated_by == updated_by) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.deleted_by, deleted_by) ||
                other.deleted_by == deleted_by) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      game_id,
      daily_game_id,
      user_id,
      game_type,
      bid_number,
      status,
      amount,
      created_by,
      created_at,
      daily_game,
      game,
      updated_by,
      updated_at,
      deleted_by,
      deleted_at);

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBetImplCopyWith<_$UserBetImpl> get copyWith =>
      __$$UserBetImplCopyWithImpl<_$UserBetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBetImplToJson(
      this,
    );
  }
}

abstract class _UserBet implements UserBet {
  const factory _UserBet(
      {required final int id,
      required final int game_id,
      required final int daily_game_id,
      required final int user_id,
      required final GameType game_type,
      required final String bid_number,
      required final Status status,
      required final String amount,
      required final int created_by,
      required final DateTime created_at,
      final DailyGame? daily_game,
      final Game? game,
      final int? updated_by,
      final DateTime? updated_at,
      final int? deleted_by,
      final DateTime? deleted_at}) = _$UserBetImpl;

  factory _UserBet.fromJson(Map<String, dynamic> json) = _$UserBetImpl.fromJson;

  @override
  int get id;
  @override
  int get game_id;
  @override
  int get daily_game_id;
  @override
  int get user_id;
  @override
  GameType get game_type;
  @override
  String get bid_number;
  @override
  Status get status;
  @override
  String get amount;
  @override
  int get created_by;
  @override
  DateTime get created_at;
  @override
  DailyGame? get daily_game;
  @override
  Game? get game;
  @override
  int? get updated_by;
  @override
  DateTime? get updated_at;
  @override
  int? get deleted_by;
  @override
  DateTime? get deleted_at;

  /// Create a copy of UserBet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBetImplCopyWith<_$UserBetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
