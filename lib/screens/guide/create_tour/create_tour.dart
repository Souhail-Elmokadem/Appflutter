import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
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
import 'package:guidanclyflutter/services/osrm_service.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class CreateTour extends ChangeNotifier {
  final Completer<GoogleMapController> mapController = Completer();
  LocationData? currentLocation;
  List<LatLng> waypoints = [];
  TourModel tourModel=  TourModel(0,"",null,"",0,0,[],0,[]);
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  final TourService tourService = TourService();
  OSRMService osrmService = OSRMService();
  final String orsApiKey = orsmApiKey; // Replace with your ORS API key
  bool _allowMarkerAddition = true; // Control when markers are allowed to be added

  CreateTour() {
    initializeCurrentLocation();
  }

  void initializeCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    notifyListeners();
  }

  void startNewTour() {
    markers.clear();
    clearTourModel();// Clear previous markers
    // Logic to create new markers
  }
  void clearTourModel() {
    tourModel = TourModel(
      0,
      // tourId
      "",
      // tourTitle
      null,
      // depart (reset to null or empty stop)
      "",
      // description
      0,
      // price
      0,
      // estimatedTime
      [],
      // stops (reset to an empty list)
      0,
      // distance
      [], // images (reset to an empty list)
    );
  }
  Future<void> addWaypoint(LatLng point, String title) async {
    if (!_allowMarkerAddition) {
      return; // Don't add markers if not allowed
    }
    print("+++++++++++++++++++++++++++++++++++");
    print("+++++++++++++++++++++++++++++++++++");
    print(tourModel.stops);

    print("+++++++++++++++++++++++++++++++++++");
    waypoints.add(point);
    tourModel.stops?.add(StopModel(name: title, location: LocationModel(point)));

    // Create marker icon
    final markerIcon = await createCustomMarker(title, "", null);

    // Add marker to the set
    markers.add(
      Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        icon: markerIcon,
        infoWindow: InfoWindow(title: title),
      ),
    );

    notifyListeners();
  }
  Future<void> clearMarkersAndPolylines() async {
    print("Clearing markers and polylines");

    waypoints.clear();
    markers.clear();
    polylineCoordinates.clear();
    polylines.clear();
    tourModel.tourTitle = null;
    tourModel.images!.clear();
    tourModel.description=null;
    tourModel.price=null;
    tourModel.stops!.clear();
    notifyListeners();
  }





  Future<BitmapDescriptor> createCustomMarker(String title,String url,double? size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Adjust these sizes based on your image dimensions and text requirements
     double imageSize = size ?? 120.0; // Size of the marker image
    const double padding = 20.0; // Padding around the text
    const double spacing = 20.0; // Space between text and marker image

    // Calculate the width based on the text length
    final double textWidth = title!.length * 40.0 + 60;
    const double textHeight = 0.0; // Height of the text box

    // Load the marker image from the assets
    final ByteData data = await rootBundle.load(url !=""?url:'assets/img/destination.png');
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
  Future<int> getStopsForCalculateDuration(List<StopModel> liststop) async {
    final List<LatLng> stops=[];
    liststop.forEach((stop) {
      if (stop.location?.point != null) {
        stops.add(stop.location!.point!);
      }
    });
    print("------------");
    int time = await osrmService.calculateWalkingTime(stops);

    //print("++++++++++++");
    //print(time.toString());

    return time;
  } // Existing code...
  Future<int> getStopsForCalculateDistance(List<StopModel> liststop) async {
    final List<LatLng> stops=[];
    liststop.forEach((stop) {
      if (stop.location?.point != null) {
        stops.add(stop.location!.point!);
      }
    });
    print("------------");
    int distance = await osrmService.calculateDistance(stops);

    //print("++++++++++++");
    //print(time.toString());

    return distance;
  }
  Future<TourModel> saveTour(String tourName, String descriptionarg, double price, List<File> listimage) async {
    _allowMarkerAddition = false; // Prevent adding markers during saving

    if (currentLocation == null || waypoints.isEmpty) {
      print('No current location or waypoints available');
      return TourModel(0, "", null, "", 0, 0, [], 0, []);
    }

    print("===========================================");
    tourModel.tourTitle = tourName;
    tourModel.description = descriptionarg;
    tourModel.depart = StopModel(name: "departTour", location: LocationModel(LatLng(markers.first.position.latitude, markers.first.position.longitude)));
    tourModel.price = price;
    tourModel.estimatedTime = await getStopsForCalculateDuration(tourModel.stops!);
    tourModel.distance = await getStopsForCalculateDistance(tourModel.stops!);
    tourModel.images = listimage;

    _allowMarkerAddition = true; // Re-enable marker addition after saving
    return tourModel;
  }
  Set<Marker> getWaypoints() {
    return markers;
  }

  void setWaypoints(Set<Marker> mrks) {
    markers=mrks;
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
