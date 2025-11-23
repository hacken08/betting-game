// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_game_with_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyGameWithGameImpl _$$DailyGameWithGameImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyGameWithGameImpl(
      id: (json['id'] as num).toInt(),
      uid: json['uid'] as String,
      name: json['name'] as String,
      start_time: DateTime.parse(json['start_time'] as String),
      end_time: DateTime.parse(json['end_time'] as String),
      max_number: (json['max_number'] as num?)?.toInt(),
      max_price: json['max_price'] as String?,
      result: json['result'] as String?,
      created_by: (json['created_by'] as num).toInt(),
      status: $enumDecode(_$StatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$DailyGameWithGameImplToJson(
        _$DailyGameWithGameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'start_time': instance.start_time.toIso8601String(),
      'end_time': instance.end_time.toIso8601String(),
      'max_number': instance.max_number,
      'max_price': instance.max_price,
      'result': instance.result,
      'created_by': instance.created_by,
      'status': _$StatusEnumMap[instance.status]!,
    };

const _$StatusEnumMap = {
  Status.ACTIVE: 'ACTIVE',
  Status.COMPLETED: 'COMPLETED',
  Status.CANCELLED: 'CANCELLED',
  Status.INACTIVE: 'INACTIVE',
  Status.UPCOMING: 'UPCOMING',
};
