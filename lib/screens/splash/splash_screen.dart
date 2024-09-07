import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guidanclyflutter/screens/Auth/signInWithNumber.dart';
import 'package:guidanclyflutter/screens/Auth/signup.dart';

import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/screens/home/home_maps.dart';
import 'package:guidanclyflutter/screens/onboard/welcome.dart';
import 'package:guidanclyflutter/screens/profile/profile_screen.dart';
import 'package:guidanclyflutter/screens/tour/tour_details.dart';
import 'package:guidanclyflutter/screens/tour/tour_reserve.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:page_transition/page_transition.dart';
import 'package:guidanclyflutter/shared/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  final String? token;

  const SplashScreen({super.key, this.token});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      color: mainColor,
      child: Image.asset("assets/img/splash.gif"),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: accessToken!=null && accessToken!=""? Home():const SignWithNumber(), //Changed
              type: PageTransitionType.fade,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 600)));
    });
  }
}
