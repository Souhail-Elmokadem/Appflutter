import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/models/reservation_model.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/tour/tour_reserve.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:page_transition/page_transition.dart';

class ScreenThnkReserve extends StatefulWidget {
  final ReservationModel reservationModel;


  const ScreenThnkReserve({super.key, required this.reservationModel});


  @override
  State<ScreenThnkReserve> createState() => _ScreenThnkReserveState();
}




class _ScreenThnkReserveState extends State<ScreenThnkReserve> {

  late Widget tourReservePage;

  @override
  void initState() {

    tourReservePage = TourReserve(visitorModel: widget.reservationModel!.visitor!,);

    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: tourReservePage, //Changed
              type: PageTransitionType.fade,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 1000)), (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: mainColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Thank You",style: TextStyle(fontFamily: 'sf-ui',fontSize: 32,fontWeight: FontWeight.bold,color: Colors.white),),
            const Text("for Your Booking!",style: TextStyle(fontFamily: 'sf-ui',fontSize: 22,fontWeight: FontWeight.w100,color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
