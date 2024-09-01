import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_state.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/location_model.dart';
import 'package:guidanclyflutter/models/stop_model.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/screens/home/home_maps.dart';
import 'package:guidanclyflutter/screens/profile/profile_screen.dart';
import 'package:guidanclyflutter/screens/widgets/bottom_navigation_bar.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   List<TourModelReceive> items =[];
   List<TourModelReceive> itemsPopular =[];
  TourService tourService = TourService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
      if (state is LayoutSuccess) {}
    }, builder: (context, state) {
      final cubit = BlocProvider.of<LayoutCubit>(context);

      if (state is LayoutSuccess) {
        return Scaffold(

          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
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
                                child: Image.network(
                                  state.user!.avatar!.replaceAll("localhost", domain),
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
                  BlocConsumer<TourCubit,TourState>(
                    listener: (context,state){},
                    builder: (context,state){
                      BlocProvider.of<TourCubit>(context).listTours!=null?
                      items = BlocProvider.of<TourCubit>(context).listTours: items=[];
                      BlocProvider.of<TourCubit>(context).listToursPopular!=null?
                      itemsPopular = BlocProvider.of<TourCubit>(context).listToursPopular: itemsPopular=[];

                      return Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
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
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          height: 80,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Find Nearby Tours ",style: TextStyle(fontFamily: 'sf-ui',fontSize: 20,fontWeight: FontWeight.w100),),
                              InkWell(
                                  onTap: (){

                                    Navigator.push(context, PageTransition(child: HomeMaps(), type: PageTransitionType.fade));

                                  },
                                  child: Icon(Icons.near_me_outlined,color: Colors.blueAccent,size: 25,)),
                            ],
                          ),
                        ),
                        //
                        SizedBox(
                          height: 15,
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
                        //listView
                        Container(
                          height: 450,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
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
                                            child: Image.network(
                                              items[index].images[0].replaceAll("localhost", domain),
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
                                                  items[index].tourTitle!,
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
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/img/locationIcon2.svg",
                                                      width: 20,
                                                      height: 20,
                                                      color: Colors.grey[400],
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    FutureBuilder<String>(
                                                      future: tourService.getCity(items[index]!.depart!.location!.point!),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Text(
                                                            "Loading...",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'sf-ui',
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.grey[400],
                                                            ),
                                                          );
                                                        } else if (snapshot.hasError) {
                                                          return Text(
                                                            "Error",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'sf-ui',
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.red[400],
                                                            ),
                                                          );
                                                        } else {
                                                          return Text(
                                                            snapshot.data ?? "Unknown",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: 'sf-ui',
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.grey[400],
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/img/tourism.svg",
                                                      width: 25,
                                                      height: 25,
                                                      color: Colors.orangeAccent[100],
                                                    ),
                                                    Text(
                                                      items[index].numberOfVisitors !=0 ?"${items[index].numberOfVisitors}+":"0",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'sf-ui',
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.orangeAccent[100]),
                                                    ),
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
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: const Column(
                              children: [
                                Text(
                                  "All popular Places",
                                  style: TextStyle(
                                      fontFamily: 'sf-ui',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //GridView
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 3 / 4,
                              mainAxisExtent: 290,

                            ),
                            itemCount: itemsPopular.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: Offset(0, 4), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 140,

                                      margin: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25)),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(itemsPopular[index].images[0].replaceAll("localhost", domain),fit: BoxFit.cover,)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemsPopular[index].tourTitle!,
                                            style: const TextStyle(
                                                fontFamily: 'sf-ui',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: 5,),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/img/locationIcon2.svg",
                                                  width: 20,
                                                  height: 20,
                                                  color: Colors.grey[400],
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                FutureBuilder<String>(
                                                  future: tourService.getCity(itemsPopular[index]!.depart!.location!.point!),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return Text(
                                                        "Loading...",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'sf-ui',
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey[400],
                                                        ),
                                                      );
                                                    } else if (snapshot.hasError) {
                                                      return Text(
                                                        "Error",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'sf-ui',
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.red[400],
                                                        ),
                                                      );
                                                    } else {
                                                      return Text(
                                                        snapshot.data ?? "Unknown",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'sf-ui',
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.grey[400],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 22,
                                                  color: Colors.yellow,
                                                ),Icon(
                                                  Icons.star,
                                                  size: 22,
                                                  color: Colors.yellow,
                                                ),Icon(
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
                                                      fontSize: 14,
                                                      fontFamily: 'sf-ui',
                                                      fontWeight:
                                                      FontWeight.w400),
                                                ),
                                              ]),
                                          SizedBox(height: 8,),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.attach_money,
                                                    size: 22,
                                                    color: Colors.blueAccent,
                                                  ),
                                                   Text(
                                                    "${itemsPopular[index].price}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'sf-ui',
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "/person",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'sf-ui',
                                                        color: Colors.grey[400],
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                    },

                  ),

                ],
              ),
            ),
          ),
        );
      } else if (state is LayoutFailure) {
        return Center(child: Text('Failed to load user data: ${state.message}'));
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
