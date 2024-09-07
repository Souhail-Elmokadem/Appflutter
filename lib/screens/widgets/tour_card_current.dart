import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/screens/tour/tour_reserve.dart';
import 'package:page_transition/page_transition.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final String review;
  final String urlimg;
  final dynamic user;

  ReviewCard({required this.user,required this.name, required this.date, required this.review,required this.urlimg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushAndRemoveUntil(context,
            PageTransition(child: TourReserve(visitorModel: user),
                type: PageTransitionType.rightToLeftWithFade),
                (Route<dynamic> route) => false
        );


      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          image:  DecorationImage(
            image: NetworkImage(urlimg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.multiply),
            alignment: Alignment.center,
          ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,fontFamily: 'sf-ui',color: Colors.white)),
                    Text("${date} DH", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 10),
                Text(review, style: TextStyle(fontSize: 14, color: Colors.grey)),

              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 30,
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Track your current tour",style: TextStyle(color: Colors.white),),
                  Icon(Icons.arrow_forward,size: 25,color: Colors.white,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
