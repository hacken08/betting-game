// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserBetImpl _$$UserBetImplFromJson(Map<String, dynamic> json) =>
    _$UserBetImpl(
      id: (json['id'] as num).toInt(),
      game_id: (json['game_id'] as num).toInt(),
      daily_game_id: (json['daily_game_id'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
      game_type: $enumDecode(_$GameTypeEnumMap, json['game_type']),
      bid_number: json['bid_number'] as String,
      status: $enumDecode(_$StatusEnumMap, json['status']),
      amount: json['amount'] as String,
      created_by: (json['created_by'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      daily_game: json['daily_game'] == null
          ? null
          : DailyGame.fromJson(json['daily_game'] as Map<String, dynamic>),
      game: json['game'] == null
          ? null
          : Game.fromJson(json['game'] as Map<String, dynamic>),
      updated_by: (json['updated_by'] as num?)?.toInt(),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deleted_by: (json['deleted_by'] as num?)?.toInt(),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$$UserBetImplToJson(_$UserBetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'game_id': instance.game_id,
      'daily_game_id': instance.daily_game_id,
      'user_id': instance.user_id,
      'game_type': _$GameTypeEnumMap[instance.game_type]!,
      'bid_number': instance.bid_number,
      'status': _$StatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'created_by': instance.created_by,
      'created_at': instance.created_at.toIso8601String(),
      'daily_game': instance.daily_game,
      'game': instance.game,
      'updated_by': instance.updated_by,
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_by': instance.deleted_by,
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };

const _$GameTypeEnumMap = {
  GameType.JODI: 'JODI',
  GameType.ANDER: 'ANDER',
  GameType.BAHER: 'BAHER',
};

const _$StatusEnumMap = {
  Status.ACTIVE: 'ACTIVE',
  Status.COMPLETED: 'COMPLETED',
  Status.CANCELLED: 'CANCELLED',
  Status.INACTIVE: 'INACTIVE',
  Status.UPCOMING: 'UPCOMING',
};
