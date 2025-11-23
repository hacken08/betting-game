// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameResult _$GameResultFromJson(Map<String, dynamic> json) {
  return _GameResult.fromJson(json);
}

/// @nodoc
mixin _$GameResult {
  int get id => throw _privateConstructorUsedError;
  int get game_id => throw _privateConstructorUsedError;
  int get daily_game_id => throw _privateConstructorUsedError;
  int get user_id => throw _privateConstructorUsedError;
  GameResultStatus get result => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  int get created_by => throw _privateConstructorUsedError;
  DateTime get created_at => throw _privateConstructorUsedError;
  DailyGame get daily_game => throw _privateConstructorUsedError;
  UserBet get user_bet => throw _privateConstructorUsedError;
  Game? get game => throw _privateConstructorUsedError;
  int? get updated_by => throw _privateConstructorUsedError;
  DateTime? get updated_at => throw _privateConstructorUsedError;
  int? get deleted_by => throw _privateConstructorUsedError;
  DateTime? get deleted_at => throw _privateConstructorUsedError;

  /// Serializes this GameResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameResultCopyWith<GameResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameResultCopyWith<$Res> {
  factory $GameResultCopyWith(
          GameResult value, $Res Function(GameResult) then) =
      _$GameResultCopyWithImpl<$Res, GameResult>;
  @useResult
  $Res call(
      {int id,
      int game_id,
      int daily_game_id,
      int user_id,
      GameResultStatus result,
      Status status,
      String amount,
      int created_by,
      DateTime created_at,
      DailyGame daily_game,
      UserBet user_bet,
      Game? game,
      int? updated_by,
      DateTime? updated_at,
      int? deleted_by,
      DateTime? deleted_at});

  $DailyGameCopyWith<$Res> get daily_game;
  $UserBetCopyWith<$Res> get user_bet;
  $GameCopyWith<$Res>? get game;
}

/// @nodoc
class _$GameResultCopyWithImpl<$Res, $Val extends GameResult>
    implements $GameResultCopyWith<$Res> {
  _$GameResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? game_id = null,
    Object? daily_game_id = null,
    Object? user_id = null,
    Object? result = null,
    Object? status = null,
    Object? amount = null,
    Object? created_by = null,
    Object? created_at = null,
    Object? daily_game = null,
    Object? user_bet = null,
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
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as GameResultStatus,
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
      daily_game: null == daily_game
          ? _value.daily_game
          : daily_game // ignore: cast_nullable_to_non_nullable
              as DailyGame,
      user_bet: null == user_bet
          ? _value.user_bet
          : user_bet // ignore: cast_nullable_to_non_nullable
              as UserBet,
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

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyGameCopyWith<$Res> get daily_game {
    return $DailyGameCopyWith<$Res>(_value.daily_game, (value) {
      return _then(_value.copyWith(daily_game: value) as $Val);
    });
  }

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserBetCopyWith<$Res> get user_bet {
    return $UserBetCopyWith<$Res>(_value.user_bet, (value) {
      return _then(_value.copyWith(user_bet: value) as $Val);
    });
  }

  /// Create a copy of GameResult
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
abstract class _$$GameResultImplCopyWith<$Res>
    implements $GameResultCopyWith<$Res> {
  factory _$$GameResultImplCopyWith(
          _$GameResultImpl value, $Res Function(_$GameResultImpl) then) =
      __$$GameResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int game_id,
      int daily_game_id,
      int user_id,
      GameResultStatus result,
      Status status,
      String amount,
      int created_by,
      DateTime created_at,
      DailyGame daily_game,
      UserBet user_bet,
      Game? game,
      int? updated_by,
      DateTime? updated_at,
      int? deleted_by,
      DateTime? deleted_at});

  @override
  $DailyGameCopyWith<$Res> get daily_game;
  @override
  $UserBetCopyWith<$Res> get user_bet;
  @override
  $GameCopyWith<$Res>? get game;
}

/// @nodoc
class __$$GameResultImplCopyWithImpl<$Res>
    extends _$GameResultCopyWithImpl<$Res, _$GameResultImpl>
    implements _$$GameResultImplCopyWith<$Res> {
  __$$GameResultImplCopyWithImpl(
      _$GameResultImpl _value, $Res Function(_$GameResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? game_id = null,
    Object? daily_game_id = null,
    Object? user_id = null,
    Object? result = null,
    Object? status = null,
    Object? amount = null,
    Object? created_by = null,
    Object? created_at = null,
    Object? daily_game = null,
    Object? user_bet = null,
    Object? game = freezed,
    Object? updated_by = freezed,
    Object? updated_at = freezed,
    Object? deleted_by = freezed,
    Object? deleted_at = freezed,
  }) {
    return _then(_$GameResultImpl(
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
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as GameResultStatus,
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
      daily_game: null == daily_game
          ? _value.daily_game
          : daily_game // ignore: cast_nullable_to_non_nullable
              as DailyGame,
      user_bet: null == user_bet
          ? _value.user_bet
          : user_bet // ignore: cast_nullable_to_non_nullable
              as UserBet,
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
class _$GameResultImpl implements _GameResult {
  const _$GameResultImpl(
      {required this.id,
      required this.game_id,
      required this.daily_game_id,
      required this.user_id,
      required this.result,
      this.status = Status.ACTIVE,
      required this.amount,
      required this.created_by,
      required this.created_at,
      required this.daily_game,
      required this.user_bet,
      this.game,
      this.updated_by,
      this.updated_at,
      this.deleted_by,
      this.deleted_at});

  factory _$GameResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameResultImplFromJson(json);

  @override
  final int id;
  @override
  final int game_id;
  @override
  final int daily_game_id;
  @override
  final int user_id;
  @override
  final GameResultStatus result;
  @override
  @JsonKey()
  final Status status;
  @override
  final String amount;
  @override
  final int created_by;
  @override
  final DateTime created_at;
  @override
  final DailyGame daily_game;
  @override
  final UserBet user_bet;
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
    return 'GameResult(id: $id, game_id: $game_id, daily_game_id: $daily_game_id, user_id: $user_id, result: $result, status: $status, amount: $amount, created_by: $created_by, created_at: $created_at, daily_game: $daily_game, user_bet: $user_bet, game: $game, updated_by: $updated_by, updated_at: $updated_at, deleted_by: $deleted_by, deleted_at: $deleted_at)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.game_id, game_id) || other.game_id == game_id) &&
            (identical(other.daily_game_id, daily_game_id) ||
                other.daily_game_id == daily_game_id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.created_by, created_by) ||
                other.created_by == created_by) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.daily_game, daily_game) ||
                other.daily_game == daily_game) &&
            (identical(other.user_bet, user_bet) ||
                other.user_bet == user_bet) &&
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
      result,
      status,
      amount,
      created_by,
      created_at,
      daily_game,
      user_bet,
      game,
      updated_by,
      updated_at,
      deleted_by,
      deleted_at);

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      __$$GameResultImplCopyWithImpl<_$GameResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameResultImplToJson(
      this,
    );
  }
}

abstract class _GameResult implements GameResult {
  const factory _GameResult(
      {required final int id,
      required final int game_id,
      required final int daily_game_id,
      required final int user_id,
      required final GameResultStatus result,
      final Status status,
      required final String amount,
      required final int created_by,
      required final DateTime created_at,
      required final DailyGame daily_game,
      required final UserBet user_bet,
      final Game? game,
      final int? updated_by,
      final DateTime? updated_at,
      final int? deleted_by,
      final DateTime? deleted_at}) = _$GameResultImpl;

  factory _GameResult.fromJson(Map<String, dynamic> json) =
      _$GameResultImpl.fromJson;

  @override
  int get id;
  @override
  int get game_id;
  @override
  int get daily_game_id;
  @override
  int get user_id;
  @override
  GameResultStatus get result;
  @override
  Status get status;
  @override
  String get amount;
  @override
  int get created_by;
  @override
  DateTime get created_at;
  @override
  DailyGame get daily_game;
  @override
  UserBet get user_bet;
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

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
