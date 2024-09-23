import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/screens/widgets/restart_widget.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class ReviewAfterBuying extends StatefulWidget {
  const ReviewAfterBuying({super.key});

  @override
  State<ReviewAfterBuying> createState() => _ReviewAfterBuyingState();
}

class _ReviewAfterBuyingState extends State<ReviewAfterBuying> {
  TourService tourService = TourService();
  VisitorModel? visitorModel;

  @override
  void initState() {
    super.initState();
    getVisitor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Tour Completed",
          style: TextStyle(fontWeight: FontWeight.bold,color: mainColor),
        ),
        centerTitle: true,
      ),
      body: visitorModel == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 120,
              color: Colors.lightGreenAccent,
            ),
            SizedBox(height: 20),
            Text(
              "Thank you for completing the tour!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We hope you had a great experience. Feel free to review your guide and share feedback.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(visitorModel: visitorModel),
                  ),
                );
              },
              icon: Icon(Icons.home),
              label: Text(
                "Back to Home",
                style: TextStyle(fontSize: 18,fontFamily: 'sf-ui'),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getVisitor() async {
    visitorModel = await tourService.getVisitor();
    setState(() {});
  }
}
