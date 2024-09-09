import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_state.dart';
import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';
import 'package:guidanclyflutter/screens/Auth/signInWithNumber.dart';
import 'package:guidanclyflutter/screens/Auth/signup.dart';
import 'package:guidanclyflutter/screens/guide/dashboard/dashboard.dart';

import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/screens/home/home_maps.dart';
import 'package:guidanclyflutter/screens/onboard/welcome.dart';
import 'package:guidanclyflutter/screens/profile/profile_screen.dart';
import 'package:guidanclyflutter/screens/tour/tour_details.dart';
import 'package:guidanclyflutter/screens/tour/tour_reserve.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
    return BlocListener<LayoutCubit,LayoutState>(
      listener: (context,state){
        if (state is LayoutSuccess<GuideModel>) {
          // Navigate to Dashboard if the user is a guide
          Timer(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: accessToken!=null && accessToken!=""? Dashboard(guideModel: state.userdetail,):const SignWithNumber(), //Changed
                    type: PageTransitionType.fade,
                    curve: Curves.bounceIn,
                    duration: const Duration(milliseconds: 600)),
                    (route) => false
            );
          });
        } else if (state is LayoutSuccess<VisitorModel>) {
          // Navigate to Home if the user is a visitor
          Timer(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: accessToken!=null && accessToken!=""? Home(visitorModel: state.userdetail,):const SignWithNumber(), //Changed
                    type: PageTransitionType.fade,
                    curve: Curves.bounceIn,
                    duration: const Duration(milliseconds: 600)),
                    (route) => false
            );
          });
        }else{
          Timer(const Duration(seconds: 3), () {
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: const SignWithNumber(), //Changed
                    type: PageTransitionType.fade,
                    curve: Curves.bounceIn,
                    duration: const Duration(milliseconds: 600)),
                    (route) => false
            );
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        color: mainColor,
        child: Image.asset("assets/img/splash.gif"),
      ),
    );
  }
  @override
  void initState() {
    super.initState();


  }
}
