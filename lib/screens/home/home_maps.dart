import 'dart:async';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/models/stop_model.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour.dart';
import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/screens/profile/profile_screen.dart';
import 'package:guidanclyflutter/screens/tour/tour_details.dart';
import 'package:guidanclyflutter/screens/widgets/maps_screen.dart';
import 'package:guidanclyflutter/screens/widgets/read_more_text.dart';
import 'package:guidanclyflutter/screens/widgets/tour_guide_avatar.dart';
import 'package:guidanclyflutter/services/osrm_service.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMaps extends StatefulWidget {
  const HomeMaps({super.key});

  @override
  State<HomeMaps> createState() => _HomeMapsState();
}

class _HomeMapsState extends State<HomeMaps> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool isSheetBottom = false;
  TourModelReceive? selectedTour =
      null; // Add a variable to keep track of the selected tour

  LocationData? currentLocation;
  OSRMService osrmService = OSRMService();
  TourService tourService = TourService();
  CreateTour createTour = CreateTour();
  Set<Marker> _markers = {}; // Store markers here
  String? cityAndPlace;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await getTours(); // Ensures getTours is awaited
    _handleMoveToCurrentLocation();
  }

  void _moveSheetToBottom() {
    _sheetController.animateTo(0.1,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      isSheetBottom = true;
    });
  }

  void _moveSheetToTop() {
    _sheetController.animateTo(0.4,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

    setState(() {
      isSheetBottom = false;
    });
  }

  Future<void> getTours() async {
    Location location = Location();
    try {
      LocationData locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        // Handle the case where location data is null
        print("Current location data is null");
        return;
      }

      setState(() {
        currentLocation = locationData;
      });

      List<LatLng> waypoints = [];
      List<Marker> markersTour = [];

      if (currentLocation == null) {
        print("Current location is null");
        return;
      }

      List<TourModelReceive> tours = await tourService.fetchNearbyTours(
          currentLocation!.latitude!, currentLocation!.longitude!);
      markersTour.add(Marker(
          markerId: MarkerId("currentPosition"),
          infoWindow: InfoWindow(title: "Your Location"),
          icon: await createTour.createCustomMarker(
              "Unnamed Stop", "assets/img/pin.png",null),
          position:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!)));

      for (TourModelReceive tour in tours) {
        // for (StopModel stop in tour.stops ?? []) {
        //   if (stop.location != null && stop.location!.point != null) {}
        //      };
        LatLng stopLatLng = LatLng(
          tour.depart!.location!.point!.latitude ??
              0.0, // Fallback to 0.0 if null
          tour.depart!.location!.point!.longitude ??
              0.0, // Fallback to 0.0 if null
        );

        waypoints.add(stopLatLng);

        Marker marker = Marker(
          markerId: MarkerId(tour.depart!.location!.point.toString()),
          position: stopLatLng,
          icon: await createTour.createCustomMarker(
              tour.depart!.name ?? "Unnamed Stop",
              "",null), // Fallback if name is null
          infoWindow: InfoWindow(
            title: tour.tourTitle ?? "Unnamed Stop", // Fallback if name is null
          ),
          onTap: () async {

              selectedTour = tour;
              if (tour.depart?.location?.point != null) {

                  cityAndPlace = await tourService.getCityAndPlace(tour.depart!.location!.point!);
                  setState(()  {
                });
              }
              print(tour); // Set the selected tour
              _moveSheetToTop(); // Show the bottom sheet with tour details

          },
        );
        markersTour.add(marker);
      }

      setState(() {
        _markers = markersTour.toSet();
        // Update markers in the state
      });

      final GoogleMapController controller = await _controller.future;
      // Move camera to the first waypoint or current location
      // if (waypoints.isNotEmpty) {
      //   controller.animateCamera(CameraUpdate.newLatLng(waypoints.first));
      // } else if (currentLocation != null) {
      //   controller.animateCamera(CameraUpdate.newLatLng(LatLng(
      //       currentLocation!.latitude!, currentLocation!.longitude!)));
      // }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _onMapCreated() {
    // Complete the controller when the map is created
    print("map charged -+++++++++++++++++++++++++++++");
    getTours();
    // Additional logic can be added here
  }

  Future<void> _handleMoveToCurrentLocation() async {
    Location location = Location();
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
      });
      print("Current location updated: $currentLocation");
      if (_controller.isCompleted) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ));
        getTours();

        print(
            "Camera moved to: ${currentLocation!.latitude!}, ${currentLocation!.longitude!}");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
    print("Location fetching completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                //Navigator.push(context, PageTransition(child: ProfileScreen(userModel: ,), type: PageTransitionType.fade));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10,35,35,0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          'https://gale-s3-bucket.s3.eu-central-1.amazonaws.com/854ac909-1404-4785-bb63-4a8917e9edb7.jpeg',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 60, 0),
                      child: Text(
                        "souhail test",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_sharp)
                  ],
                ),
              ),
            ),

            // Divider(height: 1, color: Colors.black12),
            ListView(
              padding: EdgeInsets.only(top: 30),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person_pin),
                  title: Text('Profile'),
                  onTap: () {
                    //Navigator.push(context, PageTransition(child: ProfileScreen(), type: PageTransitionType.fade));

                  },
                ),

                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);

                  },
                ),
              ],
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _moveSheetToBottom,
              child: MapsScreen(
                onMapTap: _moveSheetToBottom,
                onMoveToCurrentLocation: _handleMoveToCurrentLocation,
                controller: _controller,
                markers: _markers,
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Builder(
              builder: (context) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: IconButton(
                  padding: EdgeInsets.only(left: 5),
                  icon: Icon(Icons.arrow_back_ios, color: mainColor,size: 17,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 40,
          //   right: 16,
          //   child: Builder(
          //     builder: (context) => Padding(
          //       padding: const EdgeInsets.all(0),
          //       child: Container(
          //         width: 300,
          //         height: 50,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(50),
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey.withOpacity(0.5),
          //               spreadRadius: 1,
          //               blurRadius: 7,
          //               offset: Offset(0, 3),
          //             ),
          //           ],
          //         ),
          //         child: TextFormField(
          //           decoration: InputDecoration(
          //             prefixIcon: Icon(Icons.search, color: Colors.grey),
          //             suffixIcon: Icon(Icons.directions, color: Colors.grey),
          //             border: OutlineInputBorder(
          //               borderSide: BorderSide.none,
          //               borderRadius: BorderRadius.circular(50),
          //             ),
          //             contentPadding: EdgeInsets.symmetric(horizontal: 20),
          //             hintText: "Search in Guidancly Maps",
          //             hintStyle: TextStyle(color: Colors.grey),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 40,
            right: 16,
            child: Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      _handleMoveToCurrentLocation();
                    },
                    icon: Icon(Icons.near_me_rounded, color: mainColor,size: 18,),
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.4,
              minChildSize: 0.12,
              maxChildSize: 0.5,
              builder: (context, scrollController) {
                return GestureDetector(
                  onTap: () {
                    if (!isSheetBottom) {
                      _moveSheetToBottom();
                    } else {
                      _moveSheetToTop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                        )
                      ],
                    ),
                    child: selectedTour == null
                        ? SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Find a Tour",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'sf-ui',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                "Where do you want to go?",
                                            prefixIcon: Icon(Icons.location_on,
                                                color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        TextField(
                                          decoration: InputDecoration(
                                            hintText: "Offer your fare",
                                            prefixIcon: Icon(Icons.attach_money,
                                                color: Colors.grey),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle tour search
                                              },
                                              child: Text(
                                                'Find a Tour',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mainColor,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 90,
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle tour search
                                              },
                                              child: Icon(
                                                Icons.settings_outlined,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mainColor,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  // Add more tour details or any other widgets here
                                ],
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  if (selectedTour != null) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              selectedTour!.tourTitle ??
                                                  "Tour Title",
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              //selectedTour!.guide!.email ?? "Tour Description",
                                              cityAndPlace ??
                                                  "Loading place...",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                  fontFamily: 'sf-ui',
                                                  fontWeight: FontWeight.w100),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                        Container(
                                            width: 70,
                                            height: 70,
                                            child: TourAvatar(
                                                imageUrl: selectedTour!
                                                    .guide!.avatar!
                                                    .replaceAll("localhost",
                                                        domain))),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons
                                                .person_pin_circle_rounded),
                                            Text(
                                                " ${selectedTour!.guide!.firstName} ${selectedTour!.guide!.lastName}",
                                                style: TextStyle(
                                                    fontFamily: 'sf-ui',
                                                    fontWeight: FontWeight.w100,
                                                    fontSize: 15,
                                                    color: fourColor))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("4.7 ",
                                                style: TextStyle(
                                                    fontFamily: 'sf-ui',
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Icon(
                                              Icons.star,
                                              size: 20,
                                              color: Colors.yellow[600],
                                            ),
                                          ],
                                        ),
                                        Wrap(children: [
                                          Text(
                                            "\MAD ${selectedTour!.price}",
                                            style: TextStyle(
                                                color: mainColor,
                                                fontSize: 15,
                                                fontFamily: 'sf-ui'),
                                          ),
                                          Text(
                                            " /person",
                                            style: TextStyle(
                                                fontFamily: 'sf-ui',
                                                fontWeight: FontWeight.w100),
                                          )
                                        ]),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        if (selectedTour!.images != null && selectedTour!.images!.isNotEmpty) ...selectedTour!.images!.map((img) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(
                                              img.replaceAll("localhost", domain),  // Assuming `img` is a URL or path to the image
                                              width: 50,
                                              height: 45,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }).toList() else
                                          Text("No images available"),  // Fallback widget if images are null or empty
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Wrap(
                                        children: [
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                           Text(
                                             "About Destination",
                                             style: TextStyle(
                                                 fontSize: 20,
                                                 fontFamily: 'sf-ui'),
                                           ),
                                           selectedTour?.description != null &&
                                               selectedTour!
                                                   .description!.isNotEmpty
                                               ? ReadMoreText(
                                             text: selectedTour!
                                                 .description!,
                                           )
                                               : Text("the informations is not available about this tour !"),
                                         ],)
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: double
                                          .infinity, // Make the button take full width
                                      child: ElevatedButton(

                                        onPressed: () {
                                          // Add your onPressed code here!
                                          Navigator.push(context, PageTransition(child: TourDetails(tourModelReceive: selectedTour!,), type: PageTransitionType.rightToLeftWithFade));

                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Colors.blue, // Button text color
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16), // Button padding
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20), // Rounded corners
                                          ),
                                        ),
                                        child: Text(
                                          'See Tour',
                                          style: TextStyle(
                                            fontSize: 18, // Font size
                                            fontWeight:
                                                FontWeight.bold, // Font weight
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Add more information about the selected tour here...
                                  ] else
                                    const Center(
                                        child: Text("No tour selected")),
                                ],
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
