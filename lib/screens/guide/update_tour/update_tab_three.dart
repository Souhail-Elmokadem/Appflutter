import 'dart:async';
import 'package:guidanclyflutter/models/location_model.dart';
import 'package:guidanclyflutter/models/stop_model.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/services/osrm_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:location/location.dart';
import 'package:provider/src/consumer.dart';

class UpdateTabThree extends StatefulWidget {
  TabController? tabController;
  TourModel? tourModel;
  TourModelReceive? tourModelReceive;
  final Completer<GoogleMapController>? controller;
  UpdateTabThree(
      {super.key,
      this.tabController,
      this.tourModelReceive,
      this.tourModel,
      this.controller});

  @override
  State<UpdateTabThree> createState() => _UpdateTabThreeState();
}

class _UpdateTabThreeState extends State<UpdateTabThree> {
  List<LatLng> originalStops = [];
  GoogleMapController? _mapController;

  List<StopModel> additionalStops = [];
  Set<Polyline> _polylines = {};

  Set<Marker> markers={};

  OSRMService osrmService = OSRMService();

// Dispose of the map controller when popup is closed
  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  final CreateTour createTour = CreateTour();
  LocationData? currentLocation;
  Future<void> _handleMoveToCurrentLocation() async {
    Location location = Location();
    try {
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
      });
      print("Current location updated: $currentLocation");
      if (widget.controller!.isCompleted) {
        final GoogleMapController controller = await widget.controller!.future;
        controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ));
        print(
            "Camera moved to: ${currentLocation!.latitude!}, ${currentLocation!.longitude!}");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
    print("Location fetching completed");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("call");

    print(widget.tourModel!);
    print("+++++++++++++");

    addStopsFromTourModel(); // Rebuild markers from the tourModelReceive


  }

  Future<void> addStopsFromTourModel() async {
    markers.clear(); // Clear existing markers
    originalStops.clear();
    _polylines.clear(); // Clear existing polylines

    List<StopModel> stopsToAdd = List.from(widget.tourModelReceive!.stops!);

    for (StopModel stop in stopsToAdd) {
      if (!originalStops.contains(stop.location!.point!)) { // Prevent adding duplicates
        await addWaypoint(stop.location!.point!, stop.name!);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Consumer<CreateTour>(
                  builder: (context, createTour, child) {
                    if (createTour.currentLocation == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  child: GoogleMap(
                                    zoomControlsEnabled:
                                        false, // Disable zoom controls

                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          createTour.currentLocation!.latitude!,
                                          createTour
                                              .currentLocation!.longitude!),
                                      zoom: 14,
                                    ),
                                    onMapCreated: (controller) {
                                      // Check if the controller is already completed and if not, complete it
                                      if (!widget.controller!.isCompleted) {
                                        widget.controller!.complete(controller);
                                      }

                                      // Also complete the controller in `createTour` if it's not completed
                                      if (!createTour.mapController.isCompleted) {
                                        createTour.mapController.complete(controller);
                                      }
                                    },

                                    onTap: (position) async {
                                      String? title =
                                          await _promptForMarkerTitle(context);
                                      if (title != null) {
                                          await addWaypoint(position, title);
                                          widget.tourModel!.stops!.add(StopModel(name: title,location: LocationModel(position)));
                                      }
                                    },

                                    markers: markers,
                                    polylines: _polylines,
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      _generateTourRoute();

                                    },
                                    child: Text('Generate Route'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      textStyle: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          markers.clear(); // its not work when i click not clear markers still show
                                          _polylines.clear();
                                          widget.tourModel!.stops!.clear();
                                        });
                                      },
                                      icon: Icon(Icons.clear, color: mainColor),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Builder(
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            _handleMoveToCurrentLocation();
                                          },
                                          icon: Icon(Icons.near_me_rounded,
                                              color: mainColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String?> _promptForMarkerTitle(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Marker Title'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Marker Title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(titleController.text);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> addWaypoint(LatLng point, String title) async {


    // Create a custom marker with the title


    final markerIcon = await createTour.createCustomMarker(title,"",null);

    originalStops.add(point);
    // Add the marker to the set of markers
    setState(() {
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
    });



  }

  void _generateTourRoute() async {
    if (originalStops == null || originalStops.isEmpty) return;


    await osrmService.generateRoute(originalStops,Colors.blue,5);

    setState(() {
      _polylines = osrmService.polylines;
    });
  }
}
