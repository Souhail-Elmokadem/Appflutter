import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: mainColor,
          alignment: Alignment.center,
          child: Text("CHAT",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'sf-ui',fontSize: 40),),
        ),
      ),
    );
  }
}
