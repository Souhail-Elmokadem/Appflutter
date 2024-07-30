import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guidanclyflutter/screens/Auth/SignIn.dart';
import 'package:guidanclyflutter/screens/Auth/signInWithNumber.dart';
import 'package:guidanclyflutter/screens/onboard/welcome.dart';
import 'package:page_transition/page_transition.dart';

class Onboard3 extends StatefulWidget {
  Onboard3({super.key, required this.dots});

  final Widget dots;

  @override
  State<Onboard3> createState() => _Onboard3State();
}

class _Onboard3State extends State<Onboard3> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.1;
    final double textFontSize = size.width * 0.08;
    final double subTextFontSize = size.width * 0.05;
    final double buttonWidth = size.width * 0.8;
    final double buttonHeight = size.height * 0.08;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.5, // Give the image half the screen height
                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  child: Image.asset(
                    "assets/img/onboard1.jpg",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Life is short and the",
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontFamily: 'gemetricFont',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "world is",
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontFamily: 'gemetricFont',
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: " wide",
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontFamily: 'gemetricFont',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.9,
                margin: const EdgeInsets.only(top: 15),
                child: Text(
                  "At Friends tours and travel, we customize reliable and trustworthy educational tours to destinations all over the world.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subTextFontSize,
                    fontFamily: 'gillsansmt',
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              widget.dots,
              SizedBox(height: size.height * 0.03),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pushReplacement(context,PageTransition(child:SignWithNumber(), type: PageTransitionType.scale,alignment: Alignment.bottomCenter,childCurrent: Welcome(),duration: Duration(milliseconds: 600),curve: Curves.easeIn));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent,
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'sf-ui',
                      fontSize: subTextFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
