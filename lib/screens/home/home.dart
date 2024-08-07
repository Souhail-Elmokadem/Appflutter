import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_state.dart';
import 'package:guidanclyflutter/models/location_model.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';

class Home extends StatelessWidget {
  Home({super.key});

  List<TourModel> iteams = [
    new TourModel(
        "Nilandri Reservoir", new LocationModel("madinati", LatLng(22, 33)), []),
    new TourModel("anasi", new LocationModel("jama3", LatLng(22, 33)), []),
    new TourModel("2mars", new LocationModel("macdo", LatLng(22, 33)), []),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(listener: (context, state) {
      if (state is LayoutSuccess) {}
    }, builder: (context, state) {
      final cubit = BlocProvider.of<LayoutCubit>(context);
      if (state is LayoutSuccess) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    // Text(
                    //     'Hi ${state.user.firstName?.toUpperCase() ?? "No first name"} !',style: const TextStyle(fontSize: 40,fontFamily: 'sf-ui',color: Colors.black45),),
              
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Color(0xfff7f7f9),
                                borderRadius: BorderRadius.circular(25)),
                            padding: EdgeInsets.only(
                                left: 5, top: 5, bottom: 5, right: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.asset(
                                    "assets/img/google.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${state.user.firstName?.toUpperCase()}" ??
                                      "No first name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'sf-ui',
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                color: const Color(0xfff7f7f9),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.add_alert),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 25),
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "Explore The\n",
                              style: TextStyle(
                                  color: fourColor,
                                  fontSize: 30,
                                  fontFamily: 'sf-ui',
                                  fontWeight: FontWeight.w100)),
                          TextSpan(
                              text: "Beautiful World !",
                              style: TextStyle(
                                  color: fourColor,
                                  fontSize: 35,
                                  fontFamily: 'sf-ui',
                                  fontWeight: FontWeight.bold)),
                        ])),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Best Destination",
                            style: TextStyle(
                                fontFamily: 'sf-ui',
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "View all",
                              style: TextStyle(
                                  fontFamily: 'sf-ui',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 450,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: iteams.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 290,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0.1,
                                    offset: Offset(0, 4), // Shadow position
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width - 50,
                                    height: 280,
                                    margin: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(25)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.asset(
                                          "assets/img/image.png",
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              iteams[index].tourTitle!,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'sf-ui',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 22,
                                                    color: Colors.yellow,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "4.7",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'sf-ui',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:   MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                  SvgPicture.asset("assets/img/locationIcon2.svg",
                                                  width: 20, height: 20, color: Colors.grey[400],
                                                  ),
                                                SizedBox(width: 8,),
                                                Text(
                                                  "Casa, Azhar",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'sf-ui',
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.grey[400]),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset("assets/img/tourism.svg",
                                                  width: 25, height: 25, color: Colors.orangeAccent[100],
                                                ),
                                                Text(
                                                  " 99+",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'sf-ui',
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.orangeAccent[100]),
                                                )
              
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Column(
                          children: [
                            Text("All popular Places",
                              style: TextStyle(
                                fontFamily: 'sf-ui',
                                fontSize: 18,
                                fontWeight: FontWeight.w400),),

                          ],
                        ),
                      ),
                    ),

                    
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (state is LayoutFailure) {
        return Center(
            child: Text('Failed to load user data: ${state.message}'));
      } else {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<LayoutCubit>(context).getUserData();
              },
              child: Text("Load User Data"),
            ),
          ),
        );
      }
    });
  }
}
