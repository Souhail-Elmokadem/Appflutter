import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';

class UpdateTabThree extends StatefulWidget {
  TabController? tabController;

  TourModelReceive? tourModelReceive;
  UpdateTabThree({super.key,this.tabController,this.tourModelReceive});

  @override
  State<UpdateTabThree> createState() => _UpdateTabThreeState();
}

class _UpdateTabThreeState extends State<UpdateTabThree> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
      ),

      child: Center(child: Text("data3")),
    );
  }
}
