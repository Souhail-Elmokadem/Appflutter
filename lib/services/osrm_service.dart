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

  Future<void> generateRoute(List<LatLng> waypoints) async {

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
          width: 5,
          color: Colors.blue,
        ));

        notifyListeners();
      }
    }
  }


}
