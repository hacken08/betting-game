import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_account.freezed.dart';
part 'users_account.g.dart';

@freezed
class UsersAccount with _$UsersAccount {
  const factory UsersAccount({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'account_holder') String? accountHolder,
    @JsonKey(name: 'ifsc_code') String? ifscCode,
    @JsonKey(name: 'account_number') String? accountNumber,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'updated_by') int? updatedBy,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'deleted_by') int? deletedBy,
  }) = _UsersAccount;

  /// For JSON serialization
  factory UsersAccount.fromJson(Map<String, dynamic> json) =>
      _$UsersAccountFromJson(json);
}
