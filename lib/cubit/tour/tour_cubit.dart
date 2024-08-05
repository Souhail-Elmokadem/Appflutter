import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:http/http.dart' as http;

class TourCubit extends Cubit<TourState>{
  TourCubit(): super(TourStateInitializer());

  Future<bool> saveTour(TourModel tour) async {
    print("======================================");
    print(tour.toJson());
    print("======================================");

    try {
      emit(TourStateLoading());
      var body = json.encode(tour.toJson());
      var response = await http.post(
        Uri.parse(apiurl+'/api/tours/create'),
        headers: {'Content-Type': 'application/json',
          'Authorization':
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXNAdGVzdC50ZXN0IiwiZXhwIjoxNzIyNzEyODY4LCJpYXQiOjE3MjI3MTI4NTgsInNjb3BlIjoiVklTSVRPUiJ9.f6RbgtWzbaPQhp9Qc2nkEhjvfhKgA6jeUOJt0l_L_Zw'},
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