import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamble_app/model/game/daily_game/daily_game.dart';
import 'package:gamble_app/model/game/game.dart';
import 'package:gamble_app/model/game/user_bet/user_bet.dart';
import 'package:gamble_app/utils/enums.dart';

part 'game_result.freezed.dart';
part 'game_result.g.dart';

@freezed
class GameResult with _$GameResult {
  const factory GameResult({
    required int id,
    required int game_id,
    required int daily_game_id,
    required int user_id,
    required GameResultStatus result,
    @Default(Status.ACTIVE) Status status,
    required String amount,
    required int created_by,
    required DateTime created_at,
    required DailyGame daily_game,
    required UserBet user_bet,
    Game? game,
    int? updated_by,
    DateTime? updated_at,
    int? deleted_by,
    DateTime? deleted_at,
  }) = _GameResult;

  factory GameResult.fromJson(Map<String, dynamic> json) =>
      _$GameResultFromJson(json);
}

enum Status { ACTIVE, INACTIVE }
