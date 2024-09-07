import 'dart:convert';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/intercepteurs/auth_intercepteur.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
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

}
