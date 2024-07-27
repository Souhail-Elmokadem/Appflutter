import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/shared/constants/constants.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/base_request.dart';
import 'package:http/src/base_response.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';

class AuthInterceptor extends InterceptorContract {
  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String? accessToken = await Sharednetwork.getDataString(key: "accessToken");
    if (accessToken != null && accessToken != "") {
      request.headers['Authorization'] = "Bearer $accessToken";
      print("Added Authorization header: Bearer $accessToken");
    }
    request.headers['content-type'] = "application/json";
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode == 401) {
      final newAccessToken = await _refreshToken();
      if (newAccessToken != null) {
        final request = response.request!;
        final newRequest = _cloneRequest(request, newAccessToken);

        final client = http.Client();
        final retryStreamedResponse = await client.send(newRequest);
        final retryResponse = await http.Response.fromStream(retryStreamedResponse);
        return retryResponse;
      }
    }
    print("Response status: ${response.statusCode}");
    return response;
  }

  Future<String?> _refreshToken() async {
    String? refreshToken = await Sharednetwork.getDataString(key: "refreshToken");
    if (refreshToken == null || refreshToken == "") {
      return null;
    }

    final response = await http.post(
      Uri.parse("${apiurl}/auth/api/v1/signin"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "loginType": "refreshToken",
        "refreshToken": refreshToken
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newAccessToken = data['access-token'];
      await Sharednetwork.insertDataString(key: "accessToken", value: newAccessToken);
      await Sharednetwork.insertDataString(key: "refreshToken", value: data['refresh-token']);
      print("Access token refreshed: $newAccessToken");
      return newAccessToken;
    } else {
      // Handle refresh token failure (e.g., log out user)
      print("Failed to refresh token: ${response.statusCode}");
      return null;
    }
  }

  http.BaseRequest _cloneRequest(http.BaseRequest request, String newAccessToken) {
    final newRequest = http.Request(request.method, request.url);
    newRequest.headers.addAll(request.headers);
    newRequest.headers['Authorization'] = 'Bearer $newAccessToken';

    if (request is http.Request) {
      newRequest.bodyBytes = request.bodyBytes;
    }

    return newRequest;
  }
}
