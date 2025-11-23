import 'package:gamble_app/model/user/user.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gamble_app/service/api.dart';
import 'package:logger/logger.dart';

final userState =
    ChangeNotifierProvider.autoDispose<UserState>((ref) => UserState());

class UserState extends ChangeNotifier {
  User? thisUser = null;

  Future<bool> getUserDataById(BuildContext context, int userId) async {
    final ApiResponse data = await apiCall(
      path: "/api/user/$userId",
      body: {},
      httpMethod: HttpMethod.GET,
    );

    if (!data.status) {
      Logger().e(data.message);
      simpleRedAlert(context, data.message);
      return false;
    }
    thisUser = User.fromJson(data.data);
    notifyListeners();
    return true;
  }

  Future<bool> updateUserDataById(
    BuildContext context, {
    required int userId,
    String? name,
    String? email,
  }) async {
    Map<String, dynamic> variables = {};

    if (name != null) {
      variables["username"] = name;
    }
    if (email != null) {
      variables["email"] = email;
    }

    final ApiResponse data = await apiCall(
      httpMethod: HttpMethod.PUT,
      path: "/api/user/$userId",
      body: variables,
    );

    if (!data.status) {
      Logger().e(data.message);
      simpleRedAlert(context, data.message);
      return false;
    }
    getUserDataById(context, userId);
    return true;
  }

  Future<bool> changeUserPassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
    required String reEnterPassword,
    required int userId,
  }) async {
    final ApiResponse response = await apiCall(
      path: "/api/user/change_pass",
      body: {
        "new_password": newPassword,
        "user_id": userId,
        "current_password": currentPassword,
        "re_type_password": reEnterPassword,
      },
    );
    if (!response.status) {
      Logger().e(response.message);
      simpleRedAlert(context, response.message);
      return false;
    }
    return true;
  }
}
