import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/chat/chat.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour.dart';
import 'package:guidanclyflutter/screens/tour/tour_details.dart';
import 'package:guidanclyflutter/services/osrm_service.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart'; // Import this to access rootBundle

class TourReserve extends StatefulWidget {
  final VisitorModel visitorModel;
  const TourReserve({Key? key, required this.visitorModel}) : super(key: key);

  @override
  _TourReserveState createState() => _TourReserveState();
}

class _TourReserveState extends State<TourReserve> {
  final Completer<GoogleMapController> _controller = Completer<
      GoogleMapController>();
  final Location _location = Location();
  Set<Polyline> _polylines = {};
  final OSRMService _osrmService = OSRMService();
  Marker? _currentLocationMarker;
  LatLng? _currentLatLng;
  CreateTour createTour = CreateTour();
  final List<Marker> _stopMarkers = [];
  String _mapStyle = '';
  TourService tourService = TourService();

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
    final customMarker = await createTour.createCustomMarker(
        "Your Location", "assets/img/visitorlocation.png", 200);

    setState(() {
      _currentLatLng = latLng;
      _currentLocationMarker = Marker(
        markerId: MarkerId('current_location'),
        position: latLng,
        icon: customMarker,
      );
    });

    if (_stopMarkers.isNotEmpty) {
      LatLng destination = _stopMarkers.first
          .position; // Assuming first stop is the destination

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
        zoom: 19.0,
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
    double x = cos(startLat) * sin(endLat) -
        sin(startLat) * cos(endLat) * cos(dLng);

    double bearing = atan2(y, x);
    bearing = bearing * (180 / pi);
    bearing = (bearing + 360) % 360;

    return bearing;
  }


  void _generateTourRoute() async {
    if (_currentLatLng == null || _stopMarkers.isEmpty) return;

    LatLng firstStopLatLng = _stopMarkers.first.position;
    List<LatLng> waypoints = [_currentLatLng!, firstStopLatLng];

    await _osrmService.generateRoute(waypoints,Colors.orangeAccent,15);

    setState(() {
      _polylines = _osrmService.polylines;
    });
  }

  void _addStopMarkers(TourModelReceive tour) {
    for (var stop in tour.stops!) {
      final LatLng stopLatLng = LatLng(
          stop.location!.point!.latitude!, stop.location!.point!.longitude);

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
  Future<void> _loadMapStyle() async {
    // Load the JSON style from the asset
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Tour Progress"),
      //   backgroundColor: Colors.white,
      // ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[100],
        child: Stack(
          children: [

            Column(

              children: [
                Container(
                  height: 435,
                  padding: EdgeInsets.all(0),
                  child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),
                    child: GoogleMap(
                      mapType: MapType.terrain,

                      zoomControlsEnabled: false,
                      initialCameraPosition: _kGooglePlex,
                      markers: {
                        if (_currentLocationMarker !=
                            null) _currentLocationMarker!,
                        ..._stopMarkers,
                      },
                      polylines: _polylines,
                      // Use generated polylines
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),

                // iwant this always take bottom 0
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                ),
                width: double.infinity,
                height: 400,
                padding: EdgeInsets.only(bottom: 70),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 4,
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],

                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text("Estimated Tour Time",style: TextStyle(fontSize: 15,color: Colors.grey[400],fontFamily: 'sf-ui',),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child:Text("${(widget.visitorModel!.currentTour!.estimatedTime! / 60).round()} Minutes"??"0",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black87,fontFamily: 'sf-ui',),),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(widget.visitorModel!.avatar!.replaceAll("localhost", domain)),)
                                ,
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text("${widget.visitorModel.currentTour!.guide!.firstName!}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'sf-ui',fontSize: 16),),
                                  Text("Guide",style: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'sf-ui',),),
                                  ],
                                )
                                ],
                                ),
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: SizedBox(
                                     width: 50,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Add your onPressed code here!
                                          Navigator.push(context, PageTransition(child: Chat(), type: PageTransitionType.bottomToTop,childCurrent: TourReserve(visitorModel: widget.visitorModel),curve: Curves.easeOut,duration: Duration(milliseconds: 500)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.blueGrey,
                                          backgroundColor: Colors.grey[100],
                                          shadowColor: Colors.transparent,// Button text color
                                          padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0), // Button padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100), ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.chat_rounded,size: 22,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                Image.asset("assets/img/starting.png",width: 25,),
                                SizedBox(width: 20,),
                                Text("Starting Point in Map",style: TextStyle(fontSize: 16,fontFamily: 'sf-ui',fontWeight: FontWeight.w100),)
                              ],
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Details Tour",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'sf-ui',fontSize: 20),),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/img/distance.svg",width: 35,),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text("Tour Distance",style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'sf-ui',fontSize: 16),),
                                        Text("${widget.visitorModel!.currentTour!.distance!} meters",style: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'sf-ui',fontSize: 16),),
                                      ],),
                                    ],
                                  ),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Image.asset("assets/img/paycash.png",width: 35,),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text("Pay Cash",style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'sf-ui',fontSize: 16),),
                                        Text("${widget.visitorModel!.currentTour!.price!} DH",style: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'sf-ui',fontSize: 16,color:mainColor ),),
                                      ],),
                                    ],
                                  ),

                                ],)
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 20,
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                child: SizedBox(

                  width: MediaQuery.of(context).size.width-40,
                  // Make the button take full width
                  child: ElevatedButton(

                    onPressed: () {
                      // Add your onPressed code here!
                      tourService.makePhoneCall(widget.visitorModel.currentTour!.guide!.number!);
                      //Navigator.push(context, PageTransition(child: TourDetails(tourModelReceive: selectedTour!,), type: PageTransitionType.rightToLeftWithFade));

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                      mainColor, // Button text color
                      padding: EdgeInsets.symmetric(
                          vertical: 16), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Rounded corners
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call_outlined),
                        SizedBox(width: 10,),
                        Text(
                          'Call Guide',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'sf-ui',// Font size
                            fontWeight:
                            FontWeight.w400, // Font weight
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}
