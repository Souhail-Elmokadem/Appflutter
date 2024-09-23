import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/visitor/visitor_cubit.dart';
import 'package:guidanclyflutter/cubit/visitor/visitor_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/reservation_model.dart';
import 'package:guidanclyflutter/models/stop_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour.dart';
import 'package:guidanclyflutter/screens/tour/Screen_thnk_reserve.dart';
import 'package:guidanclyflutter/screens/tour/tour_reserve.dart';
import 'package:guidanclyflutter/screens/widgets/read_more_text.dart';
import 'package:guidanclyflutter/screens/widgets/tour_guide_avatar.dart';
import 'package:guidanclyflutter/services/message_dialog_service.dart';
import 'package:guidanclyflutter/services/osrm_service.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class TourDetails extends StatefulWidget {
  final TourModelReceive tourModelReceive;

  const TourDetails({super.key, required this.tourModelReceive});

  @override
  State<TourDetails> createState() => _TourDetailsState();
}

class _TourDetailsState extends State<TourDetails> {
  OSRMService osrmService = OSRMService();
  TourService tourService = TourService();
  bool _isFinished = false;

  final List<String> images = [
    "assets/img/nature.jpg",
    "assets/img/nature.jpg",
    "assets/img/nature.jpg",
  ];
  final DraggableScrollableController _sheetController =
  DraggableScrollableController();
  MessageDialogService messageDialogService = MessageDialogService();
  final PageController _controllerpage = PageController();
  VisitorModel? visitorModel;
  ReservationModel? reservationModel;
  bool _isAvailable=true;
  @override
  void initState() {
    super.initState();
    checkTourIsAvailable();
  }

  void checkTourIsAvailable() async {
     visitorModel = await BlocProvider.of<VisitorCubit>(context).checkVisitorTour(widget.tourModelReceive.id);
    if(visitorModel != null){
      if(visitorModel?.currentTour!.id == widget.tourModelReceive.id){
        setState(() {
          _isAvailable=false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VisitorCubit,VisitorState>(
      listener: (context,state){
        if(state is VisitorStateFailure){
          messageDialogService.showErrorDialog(context, "You don't have visitor permission!");
          _isFinished=true;
        }

      },
      builder: (context,state){
        return Scaffold(
          body: Stack(
            children: [
              // Background image with PageView
              SizedBox(
                height: 600,
                child: PageView.builder(
                  controller: _controllerpage,
                  itemCount: widget.tourModelReceive.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.network(
                        widget.tourModelReceive.images[index].replaceAll("localhost", domain),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              // SmoothPageIndicator
              Center(
                child: SmoothPageIndicator(
                  controller: _controllerpage,
                  count: widget.tourModelReceive.images.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.white.withOpacity(0.9),
                    dotColor: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              // Top Bar with Back and Bookmark buttons
              Column(
                children: [
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
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 13,
                              color: fourColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              Icons.bookmark_add_outlined,
                              size: 18,
                              color: fourColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // DraggableScrollableSheet
              DraggableScrollableActuator(
                child: DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: 0.55,
                  minChildSize: 0.4,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
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
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                // Tour Details
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 15),
                                              Text(
                                                widget.tourModelReceive.tourTitle!,
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/img/locationIcon2.svg",
                                                    fit: BoxFit.cover,
                                                    width: 18,
                                                    color: Colors.grey[400],
                                                  ),
                                                  SizedBox(width: 8),
                                                  FutureBuilder<String>(
                                                    future: tourService.getCityAndPlace(
                                                      widget.tourModelReceive.depart!.location!.point!,
                                                    ),
                                                    builder: (BuildContext context,
                                                        AsyncSnapshot<String> snapshot) {
                                                      if (snapshot.connectionState ==
                                                          ConnectionState.waiting) {
                                                        return const Text(
                                                          " Loading place...",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black54,
                                                              fontFamily: 'sf-ui',
                                                              fontWeight: FontWeight.w100),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        return const Text(
                                                          " Error",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black54,
                                                              fontFamily: 'sf-ui',
                                                              fontWeight: FontWeight.w100),
                                                        );
                                                      } else {
                                                        return Text(
                                                          snapshot.data ??
                                                              "Location Not Found",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black54,
                                                              fontFamily: 'sf-ui',
                                                              fontWeight: FontWeight.w100),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                            ],
                                          ),
                                          Container(
                                            width: 70,
                                            height: 70,
                                            child: widget.tourModelReceive.guide?.avatar! !=
                                                null
                                                ? TourAvatar(
                                                imageUrl: widget.tourModelReceive.guide!
                                                    .avatar!
                                                    .replaceAll("localhost", domain))
                                                : const Text("Image Not Found"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Wrap(
                                            children: [
                                              Icon(Icons.timer_sharp, size: 25),
                                              SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Duration",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.tourModelReceive.estimatedTime !=
                                                        null
                                                        ? "${(widget.tourModelReceive.estimatedTime! / 60).round()} minutes"
                                                        : "UNDECLARED",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Wrap(
                                            children: [
                                              Icon(Icons.monetization_on, size: 25),
                                              SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Price",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  Wrap(children: [
                                                    Text(
                                                      "${widget.tourModelReceive!.price} DH",
                                                      style: TextStyle(
                                                          color: mainColor,
                                                          fontSize: 14,
                                                          fontFamily: 'sf-ui'),
                                                    ),

                                                  ]),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                            ],
                                          ),

                                          const Wrap(
                                            children: [
                                              Icon(Icons.how_to_reg, size: 25),
                                              SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "REGISTRED",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "50+ people",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'sf-ui',
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                      ReadMoreText(
                                        text: widget.tourModelReceive!.description!,
                                        maxLength: 100,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                // Location on Map
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 260,
                                        child: GoogleMap(
                                          mapType: MapType.normal,
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                widget.tourModelReceive.depart!
                                                    .location!.point!.latitude,
                                                widget.tourModelReceive.depart!
                                                    .location!.point!.longitude),
                                            zoom: 13.5,
                                          ),
                                          zoomGesturesEnabled: true,
                                          myLocationButtonEnabled: false,
                                          tiltGesturesEnabled: false,
                                          mapToolbarEnabled: false,
                                          rotateGesturesEnabled: false,
                                          scrollGesturesEnabled: false,
                                          zoomControlsEnabled: false,

                                          markers: Set.from(
                                            widget.tourModelReceive.stops!
                                                .map((StopModel stop) {
                                              return Marker(
                                                markerId: MarkerId(stop!.name!),
                                                position: LatLng(
                                                    stop.location!.point!.latitude,
                                                    stop.location!.point!.longitude),
                                                icon: BitmapDescriptor.defaultMarker,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: FloatingActionButton(
                                        mini: true,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.zoom_out_map,
                                          color: Colors.black54,
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          // Handle map zoom out action here
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Swipeable Button


              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,

                    child: _isAvailable?SwipeableButtonView(
                      buttonText: 'SWIPE TO BOOK',
                      isFinished: _isFinished,
                      onWaitingProcess: () async {
                       reservationModel =  await BlocProvider.of<VisitorCubit>(context).book(widget.tourModelReceive.id);

                        // Checking the current state
                        var currentState = BlocProvider.of<VisitorCubit>(context).state;
                        if (currentState is VisitorStateSuccess) {
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _isFinished = true;
                            });
                          });
                        } else {
                          setState(() {
                            _isFinished = false;
                          });
                        }
                      },
                      onFinish: () async {
                        var currentState = BlocProvider.of<VisitorCubit>(context).state;
                        if (currentState is VisitorStateSuccess) {
                          await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child:  ScreenThnkReserve(reservationModel: reservationModel!,)
                              ,
                            ),
                          );
                        }
                        setState(() {
                          _isFinished = false;
                        });
                      },
                      activeColor: mainColor,
                      buttonWidget: Icon(Icons.arrow_forward_ios),
                    ):InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 600),
                            child:  TourReserve( visitorModel: visitorModel!,)

                        ));
                      },
                      child: Container(
                        height: 59,
                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: mainColor
                        ),
                        child: Text("Already Swiped !" ,style: TextStyle(color: Colors.white,fontFamily: 'sf-ui',fontSize: 16),),),
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              //     child: SizedBox(
              //       width: MediaQuery.of(context).size.width - 50,
              //
              //       child: SwipeableButtonView(
              //         buttonText: 'SWIPE TO BOOK',
              //         isFinished: _isFinished,
              //         onWaitingProcess: () async {
              //           await BlocProvider.of<VisitorCubit>(context).book(widget.tourModelReceive.id);
              //
              //           // Checking the current state
              //           var currentState = BlocProvider.of<VisitorCubit>(context).state;
              //           if (currentState is VisitorStateSuccess) {
              //             Future.delayed(Duration(seconds: 2), () {
              //               setState(() {
              //                 _isFinished = true;
              //               });
              //             });
              //           } else {
              //             setState(() {
              //               _isFinished = false;
              //             });
              //           }
              //         },
              //         onFinish: () async {
              //           var currentState = BlocProvider.of<VisitorCubit>(context).state;
              //           if (currentState is VisitorStateSuccess) {
              //             await Navigator.push(
              //               context,
              //               PageTransition(
              //                 type: PageTransitionType.fade,
              //                 child:  ScreenThnkReserve(visitorModel: BlocProvider.of<VisitorCubit>(context)!.visitorModel!,)
              //                 ,
              //               ),
              //             );
              //           }
              //           setState(() {
              //             _isFinished = false;
              //           });
              //         },
              //         activeColor: mainColor,
              //         buttonWidget: Icon(Icons.arrow_forward_ios),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },

    );
  }
}
