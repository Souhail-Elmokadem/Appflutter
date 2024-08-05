import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/models/location_model.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class CreateTour extends ChangeNotifier {
  final Completer<GoogleMapController> mapController = Completer();
  LocationData? currentLocation;
  List<LatLng> waypoints = [];
  TourModel tourModel=  TourModel("",null,[]);
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  final TourService tourService = TourService();

  final String orsApiKey =
      '5b3ce3597851110001cf62486287ac99583d441baa536d57a8d1a6b4'; // Replace with your ORS API key

  CreateTour() {
    initializeCurrentLocation();
  }

  void initializeCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    notifyListeners();
  }

  Future<void> addWaypoint(LatLng point, String title) async {
    waypoints.add(point);

    //tourModel.addstop(title,point.latitude.toString(),point.longitude.toString());



      tourModel.stops?.add(LocationModel(title,point));


    // Create a custom marker with the title
    final markerIcon = await createCustomMarker(title);

    // Add the marker to the set of markers
    markers.add(
      Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: title,
        ),
      ),

    );


    notifyListeners();
  }

  Future<void> clearMarkersAndPolylines() async {
    waypoints.clear();
    markers.clear();
    polylineCoordinates.clear();
    polylines.clear();
    notifyListeners();
  }

  Future<BitmapDescriptor> createCustomMarker(String title) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Adjust these sizes based on your image dimensions and text requirements
    const double imageSize = 120.0; // Size of the marker image
    const double padding = 20.0; // Padding around the text
    const double spacing = 20.0; // Space between text and marker image

    // Calculate the width based on the text length
    final double textWidth = title.length * 40.0 + 60;
    const double textHeight = 0.0; // Height of the text box

    // Load the marker image from the assets
    final ByteData data = await rootBundle.load('assets/img/marker.png');
    final Uint8List markerBytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(markerBytes,
        targetWidth: imageSize.toInt(), targetHeight: imageSize.toInt());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image markerImage = frameInfo.image;

    // Draw the marker image below the text with spacing
    canvas.drawImage(
        markerImage,
        Offset((textWidth / 2) - (imageSize / 2), textHeight + spacing),
        Paint());

    // Combine the text and image into one bitmap
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image combinedImage = await picture.toImage(
        textWidth.toInt(), (imageSize + textHeight + spacing).toInt());
    final ByteData? byteData =
        await combinedImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List combinedImageBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(combinedImageBytes);
  }

  // Existing code...

  Future<TourModel> saveTour(String tourName) async {
    if (currentLocation == null || waypoints.isEmpty) {
      print('No current location or waypoints available');
      return TourModel("",null,[]);
    }
    print("===========================================");
    tourModel.tourTitle= tourName;
    tourModel.depart =  LocationModel("departCity", LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
    return tourModel;
  }

  Set<Marker> getWaypoints() {
    return markers;
  }

  Set<Polyline> getPolylines() {
    return polylines;
  }

  Future<void> generateRoute() async {
    if (waypoints.isEmpty) return;

    polylineCoordinates.clear();
    polylines.clear();

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
      headers: {'Authorization': orsApiKey, 'Content-Type': 'application/json'},
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
