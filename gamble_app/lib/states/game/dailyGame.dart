import 'package:flutter/material.dart';
import 'package:gamble_app/model/game/daily_game_with_game/daily_game_with_game.dart';
import 'package:gamble_app/model/game/user_bet/user_bet.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gamble_app/service/api.dart';
import 'package:logger/logger.dart';

final dailyGameState =
    ChangeNotifierProvider.autoDispose<DailyGame>((ref) => DailyGame());

class DailyGame extends ChangeNotifier {
  List<DailyGameWithGame> gamesDisplayList = [];
  List<UserBet> usersCurrentBetsDisplayList = [];

  Future<bool> getGameByDate(BuildContext context, DateTime date) async {
    final formatDate = date.toString().split(" ")[0];
    final ApiResponse data = await apiCall(
      path: "/api/daily_game/get-by-date/${formatDate}",
      body: {},
      httpMethod: HttpMethod.GET,
    );
    if (!data.status) {
      simpleRedAlert(context, data.message.split(":")[1]);
      Logger().e(data.message);
      gamesDisplayList = [];
      return false;
    }
    gamesDisplayList = [];
    gamesDisplayList = List<DailyGameWithGame>.from(
      data.data.map(
        (item) => DailyGameWithGame.fromJson(item),
      ),
    );
    notifyListeners();
    return true;
  }

  Future<bool> makeABet(
    BuildContext context,
    int userId,
    UserBetNumber userBets,
  ) async {
    final ApiResponse response = await apiCall(
      httpMethod: HttpMethod.POST,
      path: "/api/user_bet",
      body: {
        "daily_game_id": userBets.gameId,
        "user_id": userId,
        "game_type": userBets.type.name,
        "bid_number": userBets.bidNumber,
        "amount": userBets.controller.text,
        "created_by": userId
      },
    );

    if (!response.status) {
      Logger().e(response.message);
      erroralert(
        context,
        "Unable to make bet",
        response.message,
      );
      return false;
    }

    return true;
  }

  Future<bool> getCurrentBets(
    BuildContext context,
    int userId,
    DateTime date,
  ) async {
    final ApiResponse response = await apiCall(
      path: "/api/user_bet/get-by-date",
      body: {
        "user_id": userId,
        "date": date.toString().split(" ")[0],
      },
    );
    if (!response.status) {
      Logger().e(response.message);
      simpleRedAlert(context, response.message);
      return false;
    }
    usersCurrentBetsDisplayList = List<UserBet>.from(
      response.data.map(
        (item) {
          return UserBet.fromJson(item);
        },
      ),
    );
    notifyListeners();
    return true;
  }
}
