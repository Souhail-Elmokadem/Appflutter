import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:guidanclyflutter/shared/constants/constants.dart';

class CreateTour {
  List<LatLng> waypoints = [];
  List<Polyline> polylines = [];
  Completer<GoogleMapController> mapController = Completer();
  LocationData? currentLocation;

  // Constructor
  CreateTour();

  // Add a waypoint
  void addWaypoint(LatLng point) {
    waypoints.add(point);
  }

  // Generate route using waypoints
  Future<void> generateRoute() async {
    if (waypoints.length < 2) {
      print('Select at least 2 waypoints');
      return;
    }

    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    for (int i = 0; i < waypoints.length - 1; i++) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(


        googleApiKey: apiMapsKey,
        request: PolylineRequest(origin: PointLatLng(waypoints[i].latitude, waypoints[i].longitude), destination: PointLatLng(waypoints[i + 1].latitude, waypoints[i + 1].longitude), mode: TravelMode.driving)
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    polylines.add(Polyline(
      polylineId: PolylineId('route'),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
    ));
  }

  // Initialize the current location
  Future<void> initializeCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
  }

  // Move camera to a specific location
  Future<void> moveCamera(LatLng location) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(location));
  }

  // Get the list of waypoints
  List<LatLng> getWaypoints() {
    return waypoints;
  }

  // Get the list of polylines
  List<Polyline> getPolylines() {
    return polylines;
  }
}
