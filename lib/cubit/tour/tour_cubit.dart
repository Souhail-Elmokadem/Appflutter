import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class TourCubit extends Cubit<TourState>{
  TourCubit(): super(TourStateInitializer());
  final http.Client client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: const Duration(seconds: 10),
  );
  Future<bool> saveTour(TourModel tour) async {
    print("======================================");
    print(tour.toJson());
    print("======================================");

    try {
      emit(TourStateLoading());
      var body = json.encode(tour.toJson());
      var response = await client.post(
        Uri.parse(apiurl+'/api/tours/create'),
        body: body,
      );

      if (response.statusCode == 201) {
        emit(TourStateSuccess());
        return true;
      } else {
        print('Failed to save tour: ${response.body}');
        emit(TourStateFailure());
        return false;
      }
    } catch (e) {
      print('Error saving tour: $e');
      emit(TourStateFailure());
      return false;
    }
  }


}