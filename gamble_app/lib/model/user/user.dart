import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    String? otp,
    String? email,
    String? password,
    required int id,
    required String wallet,
    required String mobile,
    required String username,
    @JsonKey(name: "refresh_token") String? refreshToken,
    @Default(Role.NONE) Role role,
    @Default(UserStatus.NONE) UserStatus status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'updated_by') int? updatedBy,
    @JsonKey(name: 'deleted_by') int? deletedBy,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
