import 'dart:convert';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/utils/const.dart';
import 'package:gamble_app/utils/custom_types.dart';
import 'package:gamble_app/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';

Future<ApiResponse> apiCall({
  required String path,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
  HttpMethod httpMethod = HttpMethod.POST,
}) async {
  try {
    final accessToken = await AuthServices.getUserToken(Session.access_token);
    Response? response;

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $accessToken',
    };

    if (headers != null) {
      requestHeaders = {
        ...headers,
        ...requestHeaders,
      };
    }

    switch (httpMethod) {
      case HttpMethod.POST:
        response = await http.post(
          Uri.parse("$baseUlr$path"),
          headers: requestHeaders,
          body: jsonEncode(
            {...body},
          ),
        );
        break;

      case HttpMethod.DELETE:
        response = await http.delete(
          Uri.parse("$baseUlr$path"),
          headers: requestHeaders,
          body: jsonEncode(
            {...body},
          ),
        );
        break;

      case HttpMethod.PUT:
        response = await http.put(
          Uri.parse("$baseUlr$path"),
          headers: requestHeaders,
          body: jsonEncode(
            {...body},
          ),
        );
        break;

      case HttpMethod.GET:
        response = await http.get(
          Uri.parse("$baseUlr$path${toQueryParams(body)}"),
          headers: requestHeaders,
        );
        break;

      default:
    }

    final responseData = jsonDecode(response!.body);
    if (responseData['data'] == null ||
        responseData['data'] == {} ||
        !responseData["status"]) {
      return ApiResponse(
        status: responseData["status"],
        data: [],
        message: responseData['message'],
      );
    }

    return ApiResponse(
      status: true,
      data: responseData['data'],
      message: '',
    );
  } catch (e) {
    Logger().e("Error communicating with backend: $e");
    return ApiResponse(
      status: false,
      data: [],
      message: e.toString(),
    );
  }
}

String toQueryParams(Map<String, dynamic> data) {
  if (data == {}) return "";
  String query = "?";
  for (final value in data.entries) {
    query += "${value.key}=${value.value}&";
  }
  return query;
}
