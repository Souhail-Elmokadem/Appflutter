import 'dart:convert';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/reservation_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:http/http.dart' as http;
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:url_launcher/url_launcher.dart';

class TourService {
  final String apiUrl = apiurl; // Replace with your API endpoint
  final http.Client client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: const Duration(seconds: 10),
  );

  Future<List<TourModelReceive>> fetchNearbyTours(double? latitude, double? longitude) async {
    // Check if latitude or longitude is null
    if (latitude == null || longitude == null) {
      throw Exception('Latitude or Longitude is null');
    }

    print("get tours by :");
    print("$latitude $longitude");

    try {
      final response = await client.get(
        Uri.parse('$apiUrl/api/tours/getToursByCurrentLocation?lat=$latitude&lng=$longitude'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> toursJson = json.decode(response.body);
        print("Tours JSON: $toursJson"); // Debugging: Print the JSON response
        return toursJson.map((t) => TourModelReceive.fromJson(t)).toList();
      }
      else {
        print(response.statusCode);
        throw Exception('Failed to load tours');
      }
    } catch (error) {
      print("Error fetching tours: $error");
      throw error;
    }
  }

  Future<String> getCityAndPlace(LatLng point) async {
    String cityAndPlace="";
    try {
      List<geo.Placemark> placemarks =
      await geo.placemarkFromCoordinates(point.latitude, point.longitude);

      if (placemarks.isNotEmpty) {

          cityAndPlace =
          "${placemarks.first.locality}, ${placemarks.first.subLocality.toString()}";
          return cityAndPlace;

      } else {

          cityAndPlace = "Unknown location";
          return cityAndPlace;
      }
    } catch (e) {
      print(e.toString());

        cityAndPlace = "Error";
      return cityAndPlace;


    }
  }
  Future<String> getCity(LatLng point) async {
    String cityAndPlace="";
    try {
      List<geo.Placemark> placemarks =
      await geo.placemarkFromCoordinates(point.latitude, point.longitude);

      if (placemarks.isNotEmpty) {

          cityAndPlace =
          "${placemarks.first.locality}";
          return cityAndPlace;

      } else {

          cityAndPlace = "Unknown location";
          return cityAndPlace;
      }
    } catch (e) {
      print(e.toString());

        cityAndPlace = "Error";
      return cityAndPlace;


    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  Future<ReservationModel?> getReservationByGuide()async {

    try{
      http.Response res = await client.get(Uri.parse("$apiurl/api/guides/getReservationByGuide"));
      if(res.statusCode == 200){
        dynamic data = jsonDecode(res.body);
        ReservationModel reservationModel = ReservationModel.fromJson(data);
        return reservationModel;
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());


    }

  }
  Future<ReservationModel?> getReservationByVisitor()async {

    try{

      http.Response res = await client.get(Uri.parse("$apiurl/api/visitor/getReservationByVisitor"));
      if(res.statusCode == 200){
        if (res.body.isNotEmpty) {
        dynamic data = jsonDecode(res.body);
        ReservationModel reservationModel = ReservationModel.fromJson(data);
        return reservationModel;
        }else{
          return null;
        }
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());


    }

  }
  Future<VisitorModel?> getVisitor()async {
    try{
      http.Response res = await client.get(Uri.parse("$apiurl/api/visitor/visitor"));
      if(res.statusCode == 200){
        dynamic data = jsonDecode(res.body);
        VisitorModel visitorModel = VisitorModel.fromJson(data);
        return visitorModel;
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());


    }

  }


}
