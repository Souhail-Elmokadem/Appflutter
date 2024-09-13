import 'package:flutter/material.dart';
import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class CreateTourCotes extends StatefulWidget {
  const CreateTourCotes({super.key});

  @override
  State<CreateTourCotes> createState() => _CreateTourCoteState();
}

class _CreateTourCoteState extends State<CreateTourCotes> {

  final FocusNode _focusNode3 = FocusNode();
  bool _isFocused3 = false;


  TextEditingController textEditingPrice = TextEditingController();
  @override
  void initState() {
    super.initState();

    _focusNode3.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) { // Check if the widget is still mounted
          setState(() {
            _isFocused3 = _focusNode3.hasFocus;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
      false, // Prevents resizing when the keyboard appears
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: mainColor, // Set the color you want for the back icon
        ),
        title: const Text("Creation of tour ",style: TextStyle(color: Colors.blue,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () async {
                final arg = (ModalRoute.of(context)?.settings.arguments ?? <String,dynamic> {}) as Map;
                Navigator.pushNamed(context,'/createTour',arguments: {'price': textEditingPrice.text,'about':arg['about'],'images':arg['images'],'guide':arg['guide']} );
              },

              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                elevation: 0,


                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("Price (MAD)",style: TextStyle(fontSize: 20,color: Colors.blue,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
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
                  keyboardType: TextInputType.number,
                  controller: textEditingPrice,
                  focusNode: _focusNode3,
                  decoration: InputDecoration(

                    hintText: "00.00 MAD",
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
