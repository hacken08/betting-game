import 'package:gamble_app/model/game/daily_game/daily_game.dart';
import 'package:gamble_app/model/game/game_result/game_result.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/service/api.dart';
import 'package:logger/logger.dart';

final gameResultState = ChangeNotifierProvider.autoDispose<GameRecordState>(
    (ref) => GameRecordState());

class GameRecordState extends ChangeNotifier {
  List<GameResult> gameRecordDisplay = [];

  Future<void> get_game_result(
      BuildContext context, int userId, int skip, int take) async {
    final response = await apiCall(
      path: "/api/game_result/user/$userId",
      body: {"skip": skip, "take": take},
      httpMethod: HttpMethod.GET,
    );

    Logger().i(response.data);
    Logger().i(response.message);

    if (!response.status) {
      Logger().e(response.message);
      erroralert(context, "Fail to load", response.message);
      return;
    }

    gameRecordDisplay = List<GameResult>.from(
      response.data.map(
        (item) {
          return GameResult.fromJson(item);
        },
      ),
    );
  }
}
