import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/cubit/layout/layout_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/models/user_model.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

final http.Client client = InterceptedClient.build(
  interceptors: [AuthInterceptor()],
  requestTimeout: const Duration(seconds: 30),
);

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitializer());
  UserModel? userModel;
  VisitorModel? visitorModel;
  Future<void> getUserData() async {
    try {
      emit(LayoutLoading());
      http.Response res = await client.get(Uri.parse("$apiurl/auth/api/v1/userinfo"));
      if (res.statusCode == 200) {
        dynamic data = jsonDecode(res.body);
        userModel = UserModel.fromJson(data['data']);
        // if(userModel is VisitorModel){
        //   print("----------------Visitor");
        // }else if(userModel is GuideModel){
        //   print("----------------Guide");
        // }
        //print("+++++++++++++++++++++++");
        // print(data);
        if(userModel!.role.toString() == "GUIDE"){
          emit(LayoutSuccess<GuideModel>(UserModel.fromJson(data['data']),GuideModel.fromJson(data['data'])));

        }else if(userModel!.role.toString() == "VISITOR"){
          emit(LayoutSuccess<VisitorModel>(UserModel.fromJson(data['data']),VisitorModel.fromJson(data['data'])));
        }
      } else {
        emit(LayoutFailure(message: "Failed to load user data"));
      }
    } catch (e) {
      emit(LayoutFailure(message: e.toString()));
    }
  }
}
