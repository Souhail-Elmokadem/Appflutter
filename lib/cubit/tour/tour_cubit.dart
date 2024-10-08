import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/services/image_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:image_picker/image_picker.dart';

class TourCubit extends Cubit<TourState>{
  TourCubit(): super(TourStateInitializer());
  final http.Client client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: const Duration(seconds: 30),
  );

  ImageService imageService = ImageService();

  Future<bool> saveTour(TourModel tour) async {
    print("======================================");
    print(tour.toJson());
    print("======================================");

    try {

      emit(TourStateLoading());

      var body = json.encode(tour.toJson());

      var response = await client.post(
        Uri.parse('$apiurl/api/tours/create'),
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

  Future<void> update(TourModel tourmodel) async{
    try {

      print(tourmodel);
      print("befaore +++++++++++++++++++++++++++++++++");
      emit(TourStateLoading());

      var body = json.encode(tourmodel.toJson());

      var response = await client.put(
        Uri.parse('$apiurl/api/tours/update'),
        body: body,
      );

      if (response.statusCode == 201) {
        emit(TourStateSuccess());
       print(response.body);
      } else {
        print('Failed to update tour: ${response.body}');
        emit(TourStateFailure());

      }
    } catch (e) {
      print('Error updating tour: $e');
      emit(TourStateFailure());

    }
  }
  Future<void> delete(int id) async{
    try {

      print(id);
      print("befaore +++++++++++++++++++++++++++++++++");
      emit(TourStateLoading());



      var response = await client.delete(
        Uri.parse('$apiurl/api/tours/delete?id=$id'),
        // body: {
        //   "id":id.toString()
        // },
      );

      if (response.statusCode == 200) {
        emit(TourStateSuccess());
       print(response.body);
      } else {
        print('Failed to update tour: ${response.body}');
        emit(TourStateFailure());

      }
    } catch (e) {
      print('Error updating tour: $e');
      emit(TourStateFailure());

    }
  }

  List<File>? listimages;
  int totalItems=0;
  List<TourModelReceive> listTours = [];
  List<TourModelReceive> listToursPopular = [];
  void getImage() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(imageQuality: 50);

    if (images != null && images.isNotEmpty && images.length <= 4) {
      List<File> imageFiles = images.map((image) => File(image.path)).toList();
      listimages = imageFiles;  // Update with compressed images
      emit(TourImagesUpdated(listimages!));
    } else if (images != null && images.length > 4) {
      emit(TourImagesFailedSize("Maximum 4 images"));
      print("Max 4 images");
    } else {
      print("No images selected");
    }
  }


  void getTours({int page = 0, String search = ""}) async {
    try {
      if (page == 0) {
        listTours.clear();
      }

      emit(TourStateLoading());

      var response = await client.get(
        Uri.parse('$apiurl/api/tours/getAllToursPage?page=$page&search=$search'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print('Tours Data: ${data}'); // Debugging

        if (data['items'] != null && data['items'] is List) {
          var toursData = data['items'] as List<dynamic>;

          totalItems = data['totalItems'];
          if (toursData.isNotEmpty) {
            listTours.addAll(toursData.map((tour) => TourModelReceive.fromJson(tour)).toList());
            emit(TourStateSuccess());
            emit(TourStateGotIt(listTours));
          } else {
            emit(TourStateEndOfPage());
          }
        } else {
          print('Invalid data format: ${data['items']}');
          emit(TourStateFailure());
        }
      } else {
        print('Failed to load tours: ${response.body}');
        emit(TourStateFailure());
      }
    } catch (e) {
      print('Error loading tours: $e');
      emit(TourStateFailure());
    }
  }



// void getToursPopular() async {
  //   try {
  //     emit(TourStateLoading());
  //
  //     var response = await client.get(
  //       Uri.parse('$apiurl/api/tours/getAllToursPage'),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //
  //       if (data['items'] != null && data['items'] is List) {
  //         var toursData = data['items'] as List<dynamic>;
  //
  //         if (toursData.isNotEmpty) {
  //           listToursPopular = toursData.map((tour) => TourModelReceive.fromJson(tour)).toList();
  //           emit(TourStateSuccess());
  //         } else {
  //           // Handle the case where the list is empty
  //           print('No tours found.');
  //           listToursPopular = [];
  //           emit(TourStateFailure()); // You might want to define a new state for empty results
  //         }
  //       } else {
  //         print('Invalid data format: ${data['items']}');
  //         emit(TourStateFailure());
  //       }
  //     } else {
  //       print('Failed to load tours: ${response.body}');
  //       emit(TourStateFailure());
  //     }
  //   } catch (e) {
  //     print('Error saving tour: $e');
  //     emit(TourStateFailure());
  //   }
  // }








}