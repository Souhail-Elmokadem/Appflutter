import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:guidanclyflutter/cubit/guide/guide_state.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
class GuideCubit extends Cubit<GuideState>{
  GuideCubit():super(GuideStateInit());

  final http.Client client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: const Duration(seconds: 30),
  );

  Future<void> getToursByGuide()async {

    try{
      emit(GuideStateLoading());
      http.Response res = await client.get(Uri.parse("$apiurl/api/guides/getToursByGuide"));
      if(res.statusCode == 200){
        dynamic data = jsonDecode(res.body);
        List<TourModelReceive> tours=[];
        for(Map<String,dynamic> t in data){
          tours.add(TourModelReceive.fromJson(t));
        }
        emit(GuideStateSuccess(tours));
      }else{
        emit(GuideStateFailed());
      }
    }catch(e){
      print(e.toString());
      emit(GuideStateFailed());

    }

  }

}