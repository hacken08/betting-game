import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/enums.dart';
// import 'package:gamble_app/lib/enu'
part 'daily_game.freezed.dart';
part 'daily_game.g.dart';

@freezed
class DailyGame with _$DailyGame {
  const factory DailyGame({
    required int id,
    String? result,
    required DailyGameStatus status,
    @JsonKey(name: 'game_id') required int game_id,
    @JsonKey(name: 'created_by') required int created_by,
    @JsonKey(name: 'updated_by') int? updated_by,
    @JsonKey(name: 'created_at') required DateTime created_at,
    @JsonKey(name: 'deleted_by') int? deleted_by,
    @JsonKey(name: 'updated_at') DateTime? updated_at,
    @JsonKey(name: 'deleted_at') DateTime? deleted_at,
  }) = _DailyGame;

  factory DailyGame.fromJson(Map<String, dynamic> json) =>
      _$DailyGameFromJson(json);
}
