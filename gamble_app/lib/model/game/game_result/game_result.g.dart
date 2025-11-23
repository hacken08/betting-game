// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameResultImpl _$$GameResultImplFromJson(Map<String, dynamic> json) =>
    _$GameResultImpl(
      id: (json['id'] as num).toInt(),
      game_id: (json['game_id'] as num).toInt(),
      daily_game_id: (json['daily_game_id'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
      result: $enumDecode(_$GameResultStatusEnumMap, json['result']),
      status:
          $enumDecodeNullable(_$StatusEnumMap, json['status']) ?? Status.ACTIVE,
      amount: json['amount'] as String,
      created_by: (json['created_by'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      daily_game:
          DailyGame.fromJson(json['daily_game'] as Map<String, dynamic>),
      user_bet: UserBet.fromJson(json['user_bet'] as Map<String, dynamic>),
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

Map<String, dynamic> _$$GameResultImplToJson(_$GameResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'game_id': instance.game_id,
      'daily_game_id': instance.daily_game_id,
      'user_id': instance.user_id,
      'result': _$GameResultStatusEnumMap[instance.result]!,
      'status': _$StatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'created_by': instance.created_by,
      'created_at': instance.created_at.toIso8601String(),
      'daily_game': instance.daily_game,
      'user_bet': instance.user_bet,
      'game': instance.game,
      'updated_by': instance.updated_by,
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_by': instance.deleted_by,
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };

const _$GameResultStatusEnumMap = {
  GameResultStatus.LOSS: 'LOSS',
  GameResultStatus.WIN: 'WIN',
};

const _$StatusEnumMap = {
  Status.ACTIVE: 'ACTIVE',
  Status.INACTIVE: 'INACTIVE',
};
