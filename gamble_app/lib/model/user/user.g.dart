// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      otp: json['otp'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      id: (json['id'] as num).toInt(),
      wallet: json['wallet'] as String,
      mobile: json['mobile'] as String,
      username: json['username'] as String,
      refreshToken: json['refresh_token'] as String?,
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']) ?? Role.NONE,
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.NONE,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      deletedBy: (json['deleted_by'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'email': instance.email,
      'password': instance.password,
      'id': instance.id,
      'wallet': instance.wallet,
      'mobile': instance.mobile,
      'username': instance.username,
      'refresh_token': instance.refreshToken,
      'role': _$RoleEnumMap[instance.role]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'deleted_by': instance.deletedBy,
    };

const _$RoleEnumMap = {
  Role.SYSTEM: 'SYSTEM',
  Role.ADMIN: 'ADMIN',
  Role.WORKER: 'WORKER',
  Role.USER: 'USER',
  Role.NONE: 'NONE',
};

const _$UserStatusEnumMap = {
  UserStatus.ACTIVE: 'ACTIVE',
  UserStatus.INACTIVE: 'INACTIVE',
  UserStatus.BLOCKED: 'BLOCKED',
  UserStatus.NONE: 'NONE',
};
