import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';

class TokenManager {
  static Future<String?> getAccessToken() async {
    return await Sharednetwork.getDataString(key: "accessToken");
  }

  static Future<String?> getRefreshToken() async {
    return await Sharednetwork.getDataString(key: "refreshToken");
  }

  static Future<void> saveAccessToken(String token) async {
    await Sharednetwork.insertDataString(key: "accessToken", value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await Sharednetwork.insertDataString(key: "refreshToken", value: token);
  }

  static Future<void> clearTokens() async {
    await Sharednetwork.deleteData(key: "accessToken");
    await Sharednetwork.deleteData(key: "refreshToken");
  }
}
