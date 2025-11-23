import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamble_app/model/game/daily_game/daily_game.dart';
import 'package:gamble_app/model/game/daily_game_with_game/daily_game_with_game.dart';
import 'package:gamble_app/model/game/game.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:logger/logger.dart';

part 'user_bet.freezed.dart';
part 'user_bet.g.dart';

@freezed
class UserBet with _$UserBet {
  const factory UserBet({
    required int id,
    required int game_id,
    required int daily_game_id,
    required int user_id,
    required GameType game_type,
    required String bid_number,
    required Status status,
    required String amount,
    required int created_by,
    required DateTime created_at,
    DailyGame? daily_game,
    Game? game,
    int? updated_by,
    DateTime? updated_at,
    int? deleted_by,
    DateTime? deleted_at,
  }) = _UserBet;

  factory UserBet.fromJson(Map<String, dynamic> json) =>
      _$UserBetFromJson(json);
}
