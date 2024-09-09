import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/screens/guide/update_tour/update_tab_one.dart';
import 'package:guidanclyflutter/screens/guide/update_tour/update_tab_three.dart';
import 'package:guidanclyflutter/screens/guide/update_tour/update_tab_two.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class UpdateTour extends StatefulWidget {
  UpdateTour({super.key,required this.tourModelReceive});

  TourModelReceive tourModelReceive;
  @override
  State<UpdateTour> createState() => _UpdateTourState();
}

class _UpdateTourState extends State<UpdateTour>  with SingleTickerProviderStateMixin{

  TourModel? tourModel;
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
     tourModel = TourModel(widget.tourModelReceive.id, widget.tourModelReceive.tourTitle, widget.tourModelReceive.depart, widget.tourModelReceive.description, widget.tourModelReceive.estimatedTime, widget.tourModelReceive.distance, widget.tourModelReceive.stops, widget.tourModelReceive.price, null);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          bottom: TabBar(
            indicatorColor: mainColor,
            dividerColor: Colors.transparent,
            controller: tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "About Tour"),
              Tab(text: "Price"),
              Tab(text: "Stops"),
            ],
          ),
          title: Text('update tour',style: TextStyle(color: Colors.white,fontSize: 22,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          // This removes the back button
          leading:
            Container(
              margin: EdgeInsets.all(5),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(Icons.arrow_back_ios,size: 18,color: Colors.white,),
                ),
              ),
            ),
        ),
        body: Container(
          color: mainColor,
          child: TabBarView(
            controller: tabController,
            children: [
              UpdateTabOne(tabController: tabController,tourModelReceive:widget.tourModelReceive,tourModel: tourModel ,),
              UpdateTabTwo(tabController: tabController,tourModelReceive:widget.tourModelReceive,tourModel: tourModel ,),
              UpdateTabThree(tabController: tabController,tourModelReceive:widget.tourModelReceive)
            ],
          ),
        ),
      ),
    );

  }
}


