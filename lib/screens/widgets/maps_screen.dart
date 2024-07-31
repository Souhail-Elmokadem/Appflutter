import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/shared/constants/constants.dart';
import 'package:location/location.dart';

class MapsScreen extends StatefulWidget {
  final Function() onMapTap;
  final Function() onMoveToCurrentLocation;
  final Completer<GoogleMapController> controller; // Accept the controller here

  MapsScreen({
    required this.onMapTap,
    required this.onMoveToCurrentLocation,
    required this.controller, // Accept the controller here
  });
  @override
  State<MapsScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapsScreen> {
  List<Marker> markers = [];
  CameraPosition? cameraPosition;
  LatLng defaultLocation = const LatLng(33.56471147828006, -7.622704915702343);
  LatLng defaultLocation1 = const LatLng(33.5694, -7.6233);
  bool locationFetched = false;
  List<LatLng> polyCord = [];
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    distancePolyline();
    getCurrentLocation();
  }

  Future<void> getCurrentPosition() async {
    print("Fetching current position...");
    bool isGeoEnable = await Geolocator.isLocationServiceEnabled();
    if (!isGeoEnable) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        markers.add(Marker(
          markerId: MarkerId("current"),
          position: LatLng(position.latitude, position.longitude),
        ));
        cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14);
      });
    }
  }

  Future<void> moveToCurrentLocation() async {
    print("Move to current location called");
    final controller = await widget.controller.future; // Use the controller from widget
    if (currentLocation != null) {
      final cameraUpdate = CameraUpdate.newLatLng(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      );
      controller.animateCamera(cameraUpdate);
    } else {
      print("Current location is null");
    }
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((value) async {
      setState(() {
        currentLocation = value;
      });
      print("Current location updated: $currentLocation");
      GoogleMapController controller = await widget.controller.future; // Use the controller from widget
      if (currentLocation != null) {
        controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ));
      }
    });

    print("Location fetching completed");
  }

  Future<void> distancePolyline() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiMapsKey,
        request: PolylineRequest(
          origin: PointLatLng(defaultLocation1.latitude, defaultLocation1.longitude),
          destination: PointLatLng(defaultLocation.latitude, defaultLocation.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (polylineResult.points.isNotEmpty) {
        polylineResult.points.forEach((PointLatLng p) => polyCord.add(LatLng(p.latitude, p.longitude)));
        setState(() {});
      } else {
        print("No points found in the polyline result.");
      }
    } catch (e) {
      print("Error fetching polyline: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? Center(child: Text("Loading..."))
        : GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        zoom: 16,
      ),
      polylines: {
        Polyline(polylineId: PolylineId("route"), points: polyCord),
      },
      markers: {
        Marker(
            markerId: MarkerId("current"),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)),
        Marker(markerId: MarkerId("dst"), position: LatLng(defaultLocation.latitude, defaultLocation.longitude)),
      },
      onMapCreated: (GoogleMapController controller) {
        widget.controller.complete(controller); // Complete the controller from widget
        if (cameraPosition != null) {
          controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
        }
      },
      onTap: (LatLng position) {
        widget.onMapTap();
      },
    );
  }
}
