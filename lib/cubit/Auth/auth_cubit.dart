

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/Auth/auth_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Authcubit extends Cubit<AuthState>{
  Authcubit() : super(InitialAuth());

  void signInWithNumber({required String number,required String password}) async{
    dynamic messageError= null;
    try{
      emit(SignInLoading());

      Response response = await http.post(Uri.parse("${apiurl}/auth/api/v1/signInWithNumber"),
          headers: {
              'Content-Type':'application/json'
          },
          body:jsonEncode({
            "number": number,
            "password": password,
            "loginType": "pass",
            "refreshToken": "no"
          }),);

      dynamic data = jsonDecode(response.body);
      messageError = data['message'];
      await Future.delayed(Duration(seconds: 2));

      String accessToken = data['access-token'];
      String refreshToken = data['refresh-token'];


      if(response.statusCode == 200 && data['success'] == "true"){
        Sharednetwork.insertDataString(key: "accessToken", value: accessToken);
        Sharednetwork.insertDataString(key: "refreshToken", value: refreshToken);
        print("Login Successful");
        emit(SignInSuccess());
      }else{

        emit(SignInFailure(message: data['message']));
        print(data);
      }

    }catch(e){
      print(messageError);
      emit(SignInFailure(message: messageError));
    }
    
  }


}