// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsersAccountImpl _$$UsersAccountImplFromJson(Map<String, dynamic> json) =>
    _$UsersAccountImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      bankName: json['bank_name'] as String?,
      accountHolder: json['account_holder'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      accountNumber: json['account_number'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      deletedBy: (json['deleted_by'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UsersAccountImplToJson(_$UsersAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'bank_name': instance.bankName,
      'account_holder': instance.accountHolder,
      'ifsc_code': instance.ifscCode,
      'account_number': instance.accountNumber,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_at': instance.updatedAt.toIso8601String(),
      'updated_by': instance.updatedBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'deleted_by': instance.deletedBy,
    };
