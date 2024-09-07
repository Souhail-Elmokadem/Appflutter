import 'package:flutter/cupertino.dart';
import 'package:guidanclyflutter/screens/Auth/signInWithNumber.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sharednetwork {
  static late SharedPreferences sharedPref;

  static Future cashInitializer() async{
  sharedPref = await SharedPreferences.getInstance();
  }

  static Future<bool> insertDataString({required String key,required String value})async{
    return await sharedPref.setString(key, value);
  }

  static String getDataString({required String key}){
    return sharedPref.getString(key) ?? "";
  }

  static Future<bool> deleteData({required String key})async{
    return await sharedPref.remove(key);
  }
  static Future<bool> signOut(BuildContext context) async {



    return await sharedPref.clear();
  }

}