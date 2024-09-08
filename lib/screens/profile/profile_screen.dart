import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/models/user_model.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/guide/dashboard/dashboard.dart';
import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/screens/profile/edit_profile_screen.dart';
import 'package:guidanclyflutter/screens/tour/tour_reserve.dart';
import 'package:guidanclyflutter/screens/widgets/bottom_navigation_bar.dart';
import 'package:guidanclyflutter/screens/widgets/restart_widget.dart';
import 'package:guidanclyflutter/screens/widgets/tour_card_current.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:guidanclyflutter/shared/shared_preferences/shared_token.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restart_app/restart_app.dart';

class ProfileScreen extends StatefulWidget {
  VisitorModel? userModel;
  ProfileScreen({super.key,required this.userModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


    Future<String> getCity() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();

      String cityAndPlace="";
      try {
        List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);

        if (placemarks.isNotEmpty) {

          cityAndPlace =
          "${placemarks.first.locality}";
          return cityAndPlace;

        } else {

          cityAndPlace = "Unknown location";
          return cityAndPlace;
        }
      } catch (e) {
        print(e.toString());

        cityAndPlace = "Error fetching location";
        return cityAndPlace;


      }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.userModel!.currentTour);
  }
  @override
  Widget build(BuildContext context)  {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              margin: EdgeInsets.fromLTRB(10, 25, 10, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25)),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 13,
                        color: fourColor,
                      ),
                    ),
                  ),
                  const Text("Profile",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'sf-ui',
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfileScreen(),) );
                    },
                    icon: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25)),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 23,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Profile Details
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.userModel?.avatar != null
                          ? NetworkImage(widget.userModel!.avatar!.replaceAll("localhost", domain))
                          : AssetImage("assets/img/person.png") as ImageProvider,
                    )
                    ,
                    SizedBox(height: 10),

                    Text(
                      widget.userModel?.firstName ?? "No data",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.location_on_sharp),
                      FutureBuilder<String>(
                        future: getCity(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              "Loading Location ...",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              "Error fetching location",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            );
                          } else {
                            return Text(
                              snapshot.data ?? "Unknown place",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            );
                          }
                        },
                      ),

                    ]),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("Visited Place",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text("1k+",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Tours",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text("1k+",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Review Section
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text("Current Tour",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10,),
                          if (widget.userModel != null && widget.userModel!.currentTour != null && widget.userModel!.currentTour!.images.isNotEmpty)
                          ReviewCard(
                            user: widget.userModel,
                            name: widget.userModel!.currentTour!.tourTitle!,
                            date: widget.userModel!.currentTour!.distance!.toString()+" meters",
                            review: widget.userModel!.currentTour!.description!,
                            urlimg: widget.userModel!.currentTour!.images[0].replaceAll("localhost", domain),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Schedule Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Next Tour",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Guide Name",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sep, 2020",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Appointment Details
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Location"),
                            Text("Tour Location"),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("View More Details ...",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Appointment Details
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [


                        ElevatedButton(
                          onPressed: () {
                            TokenManager.clearTokens();
                            Sharednetwork.signOut(context);
                            Navigator.popUntil(
                              context,
                              ModalRoute.withName('/'),
                            );
                            RestartWidget.restartApp(context);

                          },
                          child: Text("Disconnect",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

