// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      id: (json['id'] as num).toInt(),
      uid: json['uid'] as String,
      name: json['name'] as String,
      start_time: DateTime.parse(json['start_time'] as String),
      end_time: DateTime.parse(json['end_time'] as String),
      max_number: (json['max_number'] as num?)?.toInt(),
      max_price: json['max_price'] as String?,
      created_by: (json['created_by'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      updated_by: (json['updated_by'] as num?)?.toInt(),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deleted_by: (json['deleted_by'] as num?)?.toInt(),
      status: json['status'] as String,
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'start_time': instance.start_time.toIso8601String(),
      'end_time': instance.end_time.toIso8601String(),
      'max_number': instance.max_number,
      'max_price': instance.max_price,
      'created_by': instance.created_by,
      'created_at': instance.created_at.toIso8601String(),
      'updated_by': instance.updated_by,
      'updated_at': instance.updated_at?.toIso8601String(),
      'deleted_by': instance.deleted_by,
      'status': instance.status,
      'deleted_at': instance.deleted_at?.toIso8601String(),
    };
