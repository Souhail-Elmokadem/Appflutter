import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FocusNode _focusNode1 = FocusNode();
  bool _isFocused1 = false;
 final FocusNode _focusNode2 = FocusNode();
  bool _isFocused2 = false;
  final FocusNode _focusNode3 = FocusNode();
  bool _isFocused3 = false;



  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        _isFocused1 = _focusNode1.hasFocus;
      });
    });
    _focusNode2.addListener(() {
      setState(() {
        _isFocused2 = _focusNode2.hasFocus;
      });
    });
    _focusNode3.addListener(() {
      setState(() {
        _isFocused3 = _focusNode3.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),

        child: Column(

          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 25, 10, 30),
              child: Row(
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
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 13,
                        color: fourColor,
                      ),
                    ),
                  ),
                  Text("Edit Profile",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'sf-ui',
                          fontWeight: FontWeight.bold)),
                  TextButton(onPressed: (){},
                      child: Text("Done",style: TextStyle(color: mainColor,fontSize: 18),)),

                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("First Name",style: TextStyle(fontSize: 20,fontFamily: "sf-ui",fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                width: 430,
                color: Colors.white,
                child: TextFormField(
                  focusNode: _focusNode1,
                  decoration: InputDecoration(
                    hintText: "first name",
                    filled: true,
                    fillColor: _isFocused1
                        ? const Color(0xffEBEBFF)
                        : const Color(0xfff7f7f9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("Last Name",style: TextStyle(fontSize: 20,fontFamily: "sf-ui",fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                width: 430,
                color: Colors.white,
                child: TextFormField(
                  focusNode: _focusNode2,
                  decoration: InputDecoration(
                    hintText: "last name",
                    filled: true,
                    fillColor: _isFocused2
                        ? const Color(0xffEBEBFF)
                        : const Color(0xfff7f7f9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                  ),
                ),
              ),
            ),
            //
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("Email",style: TextStyle(fontSize: 20,fontFamily: "sf-ui",fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                width: 430,
                color: Colors.white,
                child: TextFormField(
                  focusNode: _focusNode3,
                  decoration: InputDecoration(
                    hintText: "email",
                    filled: true,
                    fillColor: _isFocused3
                        ? const Color(0xffEBEBFF)
                        : const Color(0xfff7f7f9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
