import 'package:flutter/material.dart';
import 'package:guidanclyflutter/screens/onboard/onboard_1.dart';
import 'package:guidanclyflutter/screens/onboard/onboard_2.dart';
import 'package:guidanclyflutter/screens/onboard/onboard_3.dart';
import 'package:guidanclyflutter/shared/theme/theme.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int indexPage = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            indexPage = index;
          });
        },
        itemCount: 3,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double opacity = 1.0;
              if (pageController.position.haveDimensions) {
                double pageValue = pageController.page ?? pageController.initialPage.toDouble();
                opacity = 1.0 - ((pageValue - index).abs() * 0.5).clamp(0.0, 1.0);
              }
              return Opacity(
                opacity: opacity,
                child: child,
              );
            },
            child: _getPage(index),
          );
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Onboard1(dots: dotes(), pagecontroller: pageController);
      case 1:
        return Onboard2(dots: dotes(),pagecontroller: pageController,);
      case 2:
        return Onboard3(dots: dotes());
      default:
        return Container();
    }
  }

  Widget dotes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          Container(
            width: indexPage == i ? 40 : 10,
            height: 10,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: indexPage == i ? Colors.blueAccent : Colors.lightBlueAccent,
            ),
          ),
      ],
    );
  }
}