import 'package:gamble_app/model/game/daily_game/daily_game.dart';
import 'package:gamble_app/model/game/game_result/game_result.dart';
import 'package:gamble_app/model/game/users_account/users_account.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/service/api.dart';
import 'package:logger/logger.dart';

final userAccountState = ChangeNotifierProvider.autoDispose<UserAccountState>(
    (ref) => UserAccountState());

class UserAccountState extends ChangeNotifier {
  List<UsersAccount> userAccountDisplay = [];

  Future<bool> getUsersAccountById(BuildContext context, int userId) async {
    final response = await apiCall(
      path: "/api/users_account/get/$userId",
      body: {},
      httpMethod: HttpMethod.GET,
    );

    if (!response.status) {
      Logger().e(response.message);
      erroralert(context, "Fail to add account", response.message);
      return false;
    }

    userAccountDisplay = List<UsersAccount>.from(
      response.data.map(
        (item) => UsersAccount.fromJson(item),
      ),
    );
    notifyListeners();
    return true;
  }

  Future<bool> create(
    BuildContext context, {
    required int userId,
    required String bankName,
    required String accountHolder,
    required String ifscCode,
    required String accountNumber,
  }) async {
    final response = await apiCall(
      path: "/api/users_account",
      body: {
        "user_id": userId,
        "bank_name": bankName,
        "account_holder": accountHolder,
        "ifsc_code": ifscCode,
        "account_number": accountNumber,
        "created_by": userId,
      },
      httpMethod: HttpMethod.POST,
    );
    if (!response.status) {
      Logger().e(response.message);
      erroralert(context, "Fail to add account", response.message);
      return false;
    }

    getUsersAccountById(context, userId);
    return true;
  }
}
