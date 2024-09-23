import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/reservation_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/screens/guide/request/tour_details_screen.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class ListRequest extends StatefulWidget {
   ListRequest({super.key,this.reservationModel});

  ReservationModel? reservationModel;
  @override
  State<ListRequest> createState() => _ListRequestState();
}

class _ListRequestState extends State<ListRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 25),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                const Text("Requests",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'sf-ui',
                        fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: (){},
                    child: Text("delete all",style: TextStyle( color: Colors.red),),
                ),

              ],
            ),
            if(widget.reservationModel != null )
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                alignment: Alignment.topLeft,
                child: InkWell(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text("New", style: TextStyle(fontFamily: 'sf-ui',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w100),)
                    )
                ),),

            if(widget.reservationModel == null )
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                alignment: Alignment.bottomCenter,
                child: InkWell(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(30)),
                        child: const Text("No Tour Swiped yet !", style: TextStyle(fontFamily: 'sf-ui',
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),)
                    )
                ),),
            if(widget.reservationModel != null )
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TourFollowScreen(reservationModel: widget.reservationModel!,),));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 120,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 8,
                            offset: Offset(0, 8))
                      ],
                      color: Colors.white,
                    ),
                    child: Row(

                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                                image: NetworkImage(widget.reservationModel!.tour!.images[0].replaceAll("localhost", domain)),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10,
                              vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.reservationModel!.tour!.tourTitle!,
                                style: TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontFamily: 'sf-ui'),),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Icon(Icons.timer_sharp, size: 15,
                                    color: Colors.grey[400],),
                                  SizedBox(width: 2,),
                                  Text("${(widget.reservationModel!.tour!.estimatedTime! / 60).round()} minutes", style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.grey[400],
                                      fontFamily: 'sf-ui'),),

                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text("Visitor: ", style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[400],
                                      fontFamily: 'sf-ui'),),
                                  Text(widget.reservationModel!.visitor!.firstName!, style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontFamily: 'sf-ui'),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 95,
                          padding: EdgeInsets.symmetric(vertical: 22),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                child: Text(widget.reservationModel!.status!, style: TextStyle(
                                    fontFamily: 'sf-ui',
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Details", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'sf-ui',
                                      color: mainColor),),
                                  SizedBox(width: 4,),
                                  Icon(Icons.arrow_forward_ios, size: 12,
                                    color: mainColor,)
                                ],
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              )


          ],
        ),
      ),
    );
  }
}
