// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyGameImpl _$$DailyGameImplFromJson(Map<String, dynamic> json) =>
    _$DailyGameImpl(
      id: (json['id'] as num).toInt(),
      result: json['result'] as String?,
      status: $enumDecode(_$DailyGameStatusEnumMap, json['status']),
      game_id: (json['game_id'] as num).toInt(),
      created_by: (json['created_by'] as num).toInt(),
      updated_by: (json['updated_by'] as num?)?.toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      deleted_by: (json['deleted_by'] as num?)?.toInt(),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$$DailyGameImplToJson(_$DailyGameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'status': _$DailyGameStatusEnumMap[instance.status]!,
      'game_id': instance.game_id,
      'created_by': instance.created_by,
      'updated_by': instance.updated_by,
      'created_at': instance.created_at.toIso8601String(),
      'deleted_by': instance.deleted_by,
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };

const _$DailyGameStatusEnumMap = {
  DailyGameStatus.UPCOMING: 'UPCOMING',
  DailyGameStatus.ACTIVE: 'ACTIVE',
  DailyGameStatus.COMPLETED: 'COMPLETED',
  DailyGameStatus.CANCELLED: 'CANCELLED',
  DailyGameStatus.INACTIVE: 'INACTIVE',
};
