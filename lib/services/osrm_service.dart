import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/location_model.dart';
import 'package:guidanclyflutter/models/stop_model.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class OSRMService extends ChangeNotifier{
  final String osrmUrl = 'http://router.project-osrm.org/route/v1/driving';
  Set<Polyline> _polylines = {}; // Private set to store polylines

  Set<Polyline> get polylines => _polylines; // Public getter // Getter to access the polylines
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final response = await http.get(Uri.parse('$osrmUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coordinates = data['routes'][0]['geometry']['coordinates'];
      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }

  Future<void> generateRoute(List<LatLng> waypoints,Color? color) async {

    if (waypoints.isEmpty) return;
    List<LatLng> polylineCoordinates=[];
    Set<Polyline> polylines={};


    List<List<double>> coordinates =
    waypoints.map((point) => [point.longitude, point.latitude]).toList();

    var body = json.encode({
      'coordinates': coordinates,
      'format': 'geojson',
      'profile': 'foot-walking',
      'units': 'm',
    });

    var response = await http.post(
      Uri.parse('https://api.openrouteservice.org/v2/directions/foot-walking'),
      headers: {'Authorization': orsmApiKey, 'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        // Get the encoded polyline string from the response
        var encodedPolyline = data['routes'][0]['geometry'];

        // Decode the polyline string into a list of LatLng points
        List<PointLatLng> decodedPolyline =
        PolylinePoints().decodePolyline(encodedPolyline);

        polylineCoordinates = decodedPolyline
            .map<LatLng>((point) => LatLng(point.latitude, point.longitude))
            .toList();

        polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          width: 15,
          color: color??Colors.blue,
        ));
        _polylines = polylines; // Update the stored polylines
        notifyListeners();
      }
    }
  }

  Future<int> calculateWalkingTime(List<LatLng> waypoints) async {
    if (waypoints.isEmpty) return 0;

    List<List<double>> coordinates = waypoints.map((point) => [point.longitude, point.latitude]).toList();

    var body = json.encode({
      'coordinates': coordinates,
      'profile': 'foot-walking',
      'units': 'm',
    });

    var response = await http.post(
      Uri.parse('https://api.openrouteservice.org/v2/directions/foot-walking'),
      headers: {'Authorization': orsmApiKey, 'Content-Type': 'application/json'},
      body: body,
    );

    print("++++++++++++++++++++++");
    print(response.body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("+++++++++++++++++++++");
      //print(data['routes'][0]['segments'][0]['duration']);
      double durationSeconds = data['routes'][0]['segments'][0]['duration'];
      int duration = durationSeconds.toInt(); // Convert seconds to minutes and round to the nearest integer
      return duration;
    } else {
      throw Exception('Failed to calculate walking time: ${response.reasonPhrase}');
    }

    return 0; // Default return if no duration could be calculated
  }
  Future<int> calculateDistance(List<LatLng> waypoints) async {
    if (waypoints.isEmpty) return 0;

    List<List<double>> coordinates = waypoints.map((point) => [point.longitude, point.latitude]).toList();

    var body = json.encode({
      'coordinates': coordinates,
      'profile': 'foot-walking',
      'units': 'm',
    });

    var response = await http.post(
      Uri.parse('https://api.openrouteservice.org/v2/directions/foot-walking'),
      headers: {'Authorization': orsmApiKey, 'Content-Type': 'application/json'},
      body: body,
    );

    print("++++++++++++++++++++++");
    print(response.body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("+++++++++++++++++++++");
      //print(data['routes'][0]['segments'][0]['duration']);
      double distanceMeters = data['routes'][0]['summary']['distance'];
      int distance = distanceMeters.toInt(); // Convert seconds to minutes and round to the nearest integer
      return distance;
    } else {
      throw Exception('Failed to calculate walking time: ${response.reasonPhrase}');
    }

    return 0; // Default return if no duration could be calculated
  }


}
