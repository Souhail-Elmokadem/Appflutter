import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'create_tour.dart';

class CreateTourPage extends StatefulWidget {
  @override
  _CreateTourPageState createState() => _CreateTourPageState();
}

class _CreateTourPageState extends State<CreateTourPage> {
  TextEditingController _tourNameController = TextEditingController();
  final FocusNode _tourfocus = FocusNode();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
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
      if (_controller.isCompleted) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ));
        print("Camera moved to: ${currentLocation!.latitude!}, ${currentLocation!.longitude!}");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
    print("Location fetching completed");
  }
  bool _isTourFocus = false;



  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          child: Image.asset("assets/img/loader.gif"),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CreateTour>(context, listen: false).initializeCurrentLocation();
    _tourfocus.addListener(() {
      setState(() {
        _isTourFocus = _tourfocus.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit,TourState>(
      listener: (context,state){
        if(state is TourStateLoading){
          _showLoadingDialog(context);
        }else if(state is TourStateSuccess){
          _showSnackBar(context, "Tour ${_tourNameController.text} Created", mainColor);
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                child:  Home(),
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              ),
              ModalRoute.withName('/'));

        }else if (state is TourStateFailure){
          Navigator.of(context).pop();
          _showErrorDialog(context, "Problem !");
        }

      },
      builder: (context,state){
        return Scaffold(
          resizeToAvoidBottomInset:
          false, // Prevents resizing when the keyboard appears
          appBar: AppBar(
            title: const Text("Creation of tour",style: TextStyle(color: Colors.blue,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    onPressed: () async {
                      String tourName = _tourNameController.text.trim();
                      if (tourName.isNotEmpty) {
                        TourModel tourModel = await Provider.of<CreateTour>(context, listen: false).saveTour(tourName);
                        await BlocProvider.of<TourCubit>(context).saveTour(tourModel);
                      } else {
                        print('Tour name cannot be empty');
                      }
                    },

                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    elevation: 0,


                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          body: Consumer<CreateTour>(
            builder: (context, createTour, child) {
              if (createTour.currentLocation == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: _tourNameController,
                          focusNode: _tourfocus,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.route_outlined,
                              color: mainColor,
                            ),
                            hintText: "tour name",
                            filled: true,
                            fillColor: _isTourFocus
                                ? const Color(0xffEBEBFF)
                                : const Color(0xfff7f7f9),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            zoomControlsEnabled: false,  // Disable zoom controls


                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  createTour.currentLocation!.latitude!,
                                  createTour.currentLocation!.longitude!),
                              zoom: 14,
                            ),
                            onMapCreated: (controller) {
                              _controller.complete(controller);
                              createTour.mapController.complete(controller);
                            },
                            onTap: (position) async {
                              String? title =
                              await _promptForMarkerTitle(context);
                              if (title != null) {
                                await createTour.addWaypoint(position, title);
                                createTour.notifyListeners();
                              }
                            },
                            markers: createTour.getWaypoints().toSet(),
                            polylines: createTour.getPolylines(),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: ElevatedButton(
                              onPressed: () async {
                                await createTour.generateRoute();
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
                                  createTour.clearMarkersAndPolylines();
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
                                      _handleMoveToCurrentLocation();
                                    },
                                    icon: Icon(Icons.near_me_rounded, color: mainColor),
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

        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tourfocus.dispose();
    _tourNameController.dispose();
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
}
