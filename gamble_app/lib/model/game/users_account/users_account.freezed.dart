// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UsersAccount _$UsersAccountFromJson(Map<String, dynamic> json) {
  return _UsersAccount.fromJson(json);
}

/// @nodoc
mixin _$UsersAccount {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_holder')
  String? get accountHolder => throw _privateConstructorUsedError;
  @JsonKey(name: 'ifsc_code')
  String? get ifscCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_number')
  String? get accountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  int? get updatedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_by')
  int? get deletedBy => throw _privateConstructorUsedError;

  /// Serializes this UsersAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsersAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsersAccountCopyWith<UsersAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersAccountCopyWith<$Res> {
  factory $UsersAccountCopyWith(
          UsersAccount value, $Res Function(UsersAccount) then) =
      _$UsersAccountCopyWithImpl<$Res, UsersAccount>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'account_holder') String? accountHolder,
      @JsonKey(name: 'ifsc_code') String? ifscCode,
      @JsonKey(name: 'account_number') String? accountNumber,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'created_by') int? createdBy,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'updated_by') int? updatedBy,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'deleted_by') int? deletedBy});
}

/// @nodoc
class _$UsersAccountCopyWithImpl<$Res, $Val extends UsersAccount>
    implements $UsersAccountCopyWith<$Res> {
  _$UsersAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? bankName = freezed,
    Object? accountHolder = freezed,
    Object? ifscCode = freezed,
    Object? accountNumber = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountHolder: freezed == accountHolder
          ? _value.accountHolder
          : accountHolder // ignore: cast_nullable_to_non_nullable
              as String?,
      ifscCode: freezed == ifscCode
          ? _value.ifscCode
          : ifscCode // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as int?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedBy: freezed == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsersAccountImplCopyWith<$Res>
    implements $UsersAccountCopyWith<$Res> {
  factory _$$UsersAccountImplCopyWith(
          _$UsersAccountImpl value, $Res Function(_$UsersAccountImpl) then) =
      __$$UsersAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'account_holder') String? accountHolder,
      @JsonKey(name: 'ifsc_code') String? ifscCode,
      @JsonKey(name: 'account_number') String? accountNumber,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'created_by') int? createdBy,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'updated_by') int? updatedBy,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'deleted_by') int? deletedBy});
}

/// @nodoc
class __$$UsersAccountImplCopyWithImpl<$Res>
    extends _$UsersAccountCopyWithImpl<$Res, _$UsersAccountImpl>
    implements _$$UsersAccountImplCopyWith<$Res> {
  __$$UsersAccountImplCopyWithImpl(
      _$UsersAccountImpl _value, $Res Function(_$UsersAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of UsersAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? bankName = freezed,
    Object? accountHolder = freezed,
    Object? ifscCode = freezed,
    Object? accountNumber = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
    Object? deletedAt = freezed,
    Object? deletedBy = freezed,
  }) {
    return _then(_$UsersAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountHolder: freezed == accountHolder
          ? _value.accountHolder
          : accountHolder // ignore: cast_nullable_to_non_nullable
              as String?,
      ifscCode: freezed == ifscCode
          ? _value.ifscCode
          : ifscCode // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as int?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedBy: freezed == deletedBy
          ? _value.deletedBy
          : deletedBy // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersAccountImpl implements _UsersAccount {
  const _$UsersAccountImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'account_holder') this.accountHolder,
      @JsonKey(name: 'ifsc_code') this.ifscCode,
      @JsonKey(name: 'account_number') this.accountNumber,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'deleted_by') this.deletedBy});

  factory _$UsersAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersAccountImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'account_holder')
  final String? accountHolder;
  @override
  @JsonKey(name: 'ifsc_code')
  final String? ifscCode;
  @override
  @JsonKey(name: 'account_number')
  final String? accountNumber;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'deleted_by')
  final int? deletedBy;

  @override
  String toString() {
    return 'UsersAccount(id: $id, userId: $userId, bankName: $bankName, accountHolder: $accountHolder, ifscCode: $ifscCode, accountNumber: $accountNumber, status: $status, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy, deletedAt: $deletedAt, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder) &&
            (identical(other.ifscCode, ifscCode) ||
                other.ifscCode == ifscCode) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.deletedBy, deletedBy) ||
                other.deletedBy == deletedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      bankName,
      accountHolder,
      ifscCode,
      accountNumber,
      status,
      createdAt,
      createdBy,
      updatedAt,
      updatedBy,
      deletedAt,
      deletedBy);

  /// Create a copy of UsersAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersAccountImplCopyWith<_$UsersAccountImpl> get copyWith =>
      __$$UsersAccountImplCopyWithImpl<_$UsersAccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersAccountImplToJson(
      this,
    );
  }
}

abstract class _UsersAccount implements UsersAccount {
  const factory _UsersAccount(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'bank_name') final String? bankName,
      @JsonKey(name: 'account_holder') final String? accountHolder,
      @JsonKey(name: 'ifsc_code') final String? ifscCode,
      @JsonKey(name: 'account_number') final String? accountNumber,
      @JsonKey(name: 'status') required final String status,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'created_by') final int? createdBy,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'updated_by') final int? updatedBy,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      @JsonKey(name: 'deleted_by') final int? deletedBy}) = _$UsersAccountImpl;

  factory _UsersAccount.fromJson(Map<String, dynamic> json) =
      _$UsersAccountImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'account_holder')
  String? get accountHolder;
  @override
  @JsonKey(name: 'ifsc_code')
  String? get ifscCode;
  @override
  @JsonKey(name: 'account_number')
  String? get accountNumber;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'created_by')
  int? get createdBy;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'updated_by')
  int? get updatedBy;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'deleted_by')
  int? get deletedBy;

  /// Create a copy of UsersAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersAccountImplCopyWith<_$UsersAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
