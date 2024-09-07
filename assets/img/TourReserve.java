import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/guide/create_tour.dart';
import 'package:guidanclyflutter/services/osrm_service.dart';
import 'package:location/location.dart';

class TourReserve extends StatefulWidget {
  final VisitorModel visitorModel;
  const TourReserve({Key? key, required this.visitorModel}) : super(key: key);

  @override
  _TourReserveState createState() => _TourReserveState();
}

class _TourReserveState extends State<TourReserve> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Location _location = Location();
  Set<Polyline> _polylines = {};
  final OSRMService _osrmService = OSRMService();
  Marker? _currentLocationMarker;
  LatLng? _currentLatLng;
  CreateTour createTour = CreateTour();
  final List<Marker> _stopMarkers = [];

  @override
  void initState() {
    super.initState();

    // Listen to location changes
    _location.onLocationChanged.listen((LocationData locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        LatLng latLng = LatLng(locationData.latitude!, locationData.longitude!);
        _updateLocation(latLng);
      }
    });

    // Add stop markers if the visitor has a current tour
    if (widget.visitorModel.currentTour != null) {
      _addStopMarkers(widget.visitorModel.currentTour!);
    }
  }

  void _updateLocation(LatLng latLng) async {
    final customMarker = await createTour.createCustomMarker("Your Location", "assets/img/pin.png");

    setState(() {
      _currentLatLng = latLng;
      _currentLocationMarker = Marker(
        markerId: MarkerId('current_location'),
        position: latLng,
        icon: customMarker,
      );
    });

    if (_stopMarkers.isNotEmpty) {
      LatLng destination = _stopMarkers.first.position; // Assuming first stop is the destination

      double bearing = _calculateBearing(latLng, destination);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 19.0,
        tilt: 70,
        bearing: bearing,
      )));
    } else {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 22.0,
        tilt: 70,
      )));
    }

    _generateTourRoute(); // Generate the route once the location is updated
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double startLat = start.latitude * (pi / 180);
    double startLng = start.longitude * (pi / 180);
    double endLat = end.latitude * (pi / 180);
    double endLng = end.longitude * (pi / 180);

    double dLng = endLng - startLng;

    double y = sin(dLng) * cos(endLat);
    double x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

    double bearing = atan2(y, x);
    bearing = bearing * (180 / pi);
    bearing = (bearing + 360) % 360;

    return bearing;
  }


  void _generateTourRoute() async {
    if (_currentLatLng == null || _stopMarkers.isEmpty) return;

    LatLng firstStopLatLng = _stopMarkers.first.position;
    List<LatLng> waypoints = [_currentLatLng!, firstStopLatLng];

    await _osrmService.generateRoute(waypoints);

    setState(() {
      _polylines = _osrmService.polylines;
    });
  }

  void _addStopMarkers(TourModelReceive tour) {
    for (var stop in tour.stops!) {
      final LatLng stopLatLng = LatLng(stop.location!.point!.latitude!, stop.location!.point!.longitude);

      final Marker marker = Marker(
        markerId: MarkerId(stop.name!),
        position: stopLatLng,
        infoWindow: InfoWindow(title: stop.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );

      setState(() {
        _stopMarkers.add(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Tour Progress"),
      //   backgroundColor: Colors.white,
      // ),
      body: Stack(
        children: [

          Column(
          children: [
            Container(
              height: 400,
             padding: EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: {
                    if (_currentLocationMarker != null) _currentLocationMarker!,
                    ..._stopMarkers,
                  },
                  polylines: _polylines, // Use generated polylines
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(50),
                value: 0.7,
                backgroundColor: Colors.grey[300],
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),

        ],
      ),
    );
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

