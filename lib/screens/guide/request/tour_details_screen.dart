import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guidanclyflutter/cubit/guide/guide_cubit.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/reservation_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/models/stop_model.dart';
import 'package:guidanclyflutter/screens/chat/chat.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:page_transition/page_transition.dart';

class TourFollowScreen extends StatefulWidget {
  final ReservationModel reservationModel;

   TourFollowScreen({Key? key, required this.reservationModel})
      : super(key: key);

  @override
  State<TourFollowScreen> createState() => _TourFollowScreenState();
}

class _TourFollowScreenState extends State<TourFollowScreen> {
  TourService tourService = TourService();

  Timer? _timer;
  int _start = 0;

  @override
  void initState() {
    startTimer();
  } // Time in seconds



  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _start += 1;  // Increase time by 1 second
      });

    });
  }
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;  // Integer division
    int remainingSeconds = seconds % 60;
    if(minutes ==0){
      return '${remainingSeconds}s';
    }
    return '${minutes}m:${remainingSeconds}s';  // Format as 'minutes:seconds'
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                color: mainColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 22,),
                      )),
                      SizedBox(width: 15,),
                      Text("Tour Tracking", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'sf-ui'),),
                      SizedBox(width: 8,),
                      Icon(Icons.timer_sharp,size: 22,color: Colors.white,),
                      SizedBox(width: 8,),
                      Text(formatTime(_start), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w100,color: Colors.white,fontFamily: 'sf-ui'),),

                    ],
                  ),
                ),
              ),

              // Tour Title and Description
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 100),
                height: 800,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 80,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[200]
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reservationModel.tour!.tourTitle!.substring(0,1).toUpperCase()+ widget.reservationModel.tour!.tourTitle!.substring(1),
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,fontFamily: 'sf-ui',color: mainColor),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Description: ${widget.reservationModel.tour!.description!}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 50),

                          // Tour Price and Distance Information
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
                                      Text("${widget.reservationModel.tour!.distance} meters",style: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'sf-ui',fontSize: 16),),
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
                                      Text("Get Cash",style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'sf-ui',fontSize: 16),),
                                      Text("${widget.reservationModel.tour!.price} DH",style: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'sf-ui',fontSize: 16,color:mainColor ),),
                                    ],),
                                ],
                              ),

                            ],),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(widget.reservationModel.visitor!.avatar!.replaceAll("localhost", domain)),radius: 35,
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${widget.reservationModel.visitor!.firstName!}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'sf-ui',fontSize: 16),),
                                      Text("Visitor",style: TextStyle(fontWeight: FontWeight.w100,fontFamily: 'sf-ui',),),
                                    ],
                                  ),

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
                                        Navigator.push(context, PageTransition(child: Chat(), type: PageTransitionType.bottomToTop,curve: Curves.easeOut,duration: Duration(milliseconds: 500)));
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
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10,bottom: 15),
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Add your onPressed code here!
                                            tourService.makePhoneCall("0${widget.reservationModel.visitor!.number!}");
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
                                          Icon(Icons.call,size: 22,),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],)

                            ],
                          ),
                          SizedBox(height: 30),

                          // Stops List
                          Text(
                            'Stops:',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.reservationModel.tour!.stops?.length ?? 0,
                        itemBuilder: (context, index) {
                          final StopModel stop = widget.reservationModel!.tour!.stops![index];
                          return StopCard(stop: stop, index: index + 1);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Show confirmation dialog when "Complete Tour" button is pressed
                _showConfirmationDialog(
                  context,
                  'Complete Tour',
                  'Are you sure you want to complete the tour?',mainColor,
                      () async{
                    await BlocProvider.of<GuideCubit>(context).completed(widget.reservationModel.visitor!.email!);

                    Navigator.of(context).pop(); // Close the dialog
                        Navigator.pop(context);
                    context.read<GuideCubit>().getToursByGuide(); // Refresh data if needed
                      },
                );
              },
              label: Text('Complete Tour'),
              icon: Icon(Icons.check),
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                // Show confirmation dialog when "Cancel Tour" button is pressed
                _showConfirmationDialog(
                  context,
                  'Cancel Tour',
                  'Are you sure you want to cancel the tour?',Colors.redAccent,
                      () {
                    // Logic to cancel the tour
                    print('Tour Cancelled!');
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              },
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              child: Icon(Icons.cancel_outlined),
            ),
          ),
        ],
      ),


    );
  }
}

// Card widget to display stop details
class StopCard extends StatelessWidget {
  final StopModel stop;
  final int index;

  const StopCard({Key? key, required this.stop, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: mainColor.withOpacity(0.7),
          child: Text(
            index.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          stop.name!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(stop!.name! ?? 'No description provided'),
        trailing: IconButton(
          icon: Icon(Icons.location_on, color: mainColor.withOpacity(0.7)),
          onPressed: () {
            // Handle action to view stop on the map
          },
        ),
      ),
    );
  }
}
void _showConfirmationDialog(BuildContext context, String title, String message,Color color, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          ElevatedButton(
            style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white),backgroundColor:WidgetStatePropertyAll(color) ),
            child: Text('Confirm'),
            onPressed: onConfirm, // Call the onConfirm callback
          ),
        ],
      );
    },
  );
}
