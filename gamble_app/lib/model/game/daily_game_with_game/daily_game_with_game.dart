import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamble_app/utils/enums.dart';

part 'daily_game_with_game.freezed.dart';
part 'daily_game_with_game.g.dart';

@freezed
class DailyGameWithGame with _$DailyGameWithGame {
  const factory DailyGameWithGame({
    // Fields from `games` table
    required int id,
    required String uid,
    required String name,
    required DateTime start_time,
    required DateTime end_time,
    int? max_number,
    String? max_price,
    String? result,
    required int created_by,
    required Status status,
  }) = _DailyGameWithGame;

  factory DailyGameWithGame.fromJson(Map<String, dynamic> json) =>
      _$DailyGameWithGameFromJson(json);
}
