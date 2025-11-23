import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required int id,
    required String uid,
    required String name,
    @JsonKey(name: 'start_time') required DateTime start_time,
    @JsonKey(name: 'end_time') required DateTime end_time,
    @JsonKey(name: 'max_number') int? max_number,
    @JsonKey(name: 'max_price') String? max_price,
    @JsonKey(name: 'created_by') required int created_by,
    @JsonKey(name: 'created_at') required DateTime created_at,
    @JsonKey(name: 'updated_by') int? updated_by,
    @JsonKey(name: 'updated_at') DateTime? updated_at,
    @JsonKey(name: 'deleted_by') int? deleted_by,
    required String status,
    @JsonKey(name: 'deleted_at') DateTime? deleted_at,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
