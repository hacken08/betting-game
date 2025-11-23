import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/view/profile/profile.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/service/api.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class AuthServices {
  static Future<bool> signInUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    final ApiResponse responseData = await apiCall(
      path: "/api/auth/login",
      body: {
        "mobile": email,
        "password": password,
      },
    );

    if (!responseData.status) {
      if (!context.mounted) return false;
      simpleRedAlert(context, responseData.message);
      return false;
    }

    final authData = responseData.data;
    final Map<String, dynamic> session = {
      Session.id.toString(): authData["id"],
      Session.role.toString(): authData["role"],
      Session.access_token.toString(): authData["access_token"],
      Session.refresh_token.toString(): authData["refresh_token"],
    };
    await setSession(session);
    return true;
  }

  static Future<bool> signUpUser(BuildContext context, String username,
      String email, String password, String mobileNumber) async {
    final ApiResponse responseData = await apiCall(
      path: "/api/user/create",
      body: {
        "name": username,
        "email": email,
        "password": password,
        "number": mobileNumber,
        "role": "USER",
      },
    );

    if (!responseData.status) {
      if (!context.mounted) return false;
      simpleRedAlert(context, responseData.message);
      return false;
    }
    return true;
  }

  static Future<void> setSession(Map data) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final isSessionCreated = await storage.setString(
      "session",
      jsonEncode(data),
    );
  }

  static Future<int> getUserId<T>({BuildContext? context}) async {
    SharedPreferences storeage = await SharedPreferences.getInstance();
    String? session = storeage.getString("session");
      if (session == null) {
      if (context == null) return 0;
      context.go('/login');
      return 0;
    }

    Map<String, dynamic> jsonSession = jsonDecode(session);
    return jsonSession[Session.id.toString()];
  }

  static Future<String> getUserToken<T>(Session key, {BuildContext? context}) async {
    SharedPreferences storeage = await SharedPreferences.getInstance();
    String? session = storeage.getString("session");
    if (session == null) {
      if (context == null) return "";
      context.go('/login');
      return "";
    }

    Map<String, dynamic> jsonSession = jsonDecode(session);
    if (key == Session.id || key == Session.role) return "";
    return jsonSession[key.toString()];
  }

  static Future<String> getUserRole<T>({BuildContext? context}) async {
    SharedPreferences storeage = await SharedPreferences.getInstance();
    String? session = storeage.getString("session");
    if (session == null) {
      if (context == null) return "";
      context.go('/login');
      return "";
    }

    Map<String, dynamic> jsonSession = jsonDecode(session);
    return jsonSession[Session.role.toString()];
  }

  static Future<String?> getSession() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString("session");
  }

  static Future<bool> deleteSession() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    return await storage.remove("session");
  }
}
