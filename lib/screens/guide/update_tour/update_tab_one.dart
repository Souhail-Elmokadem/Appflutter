import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class UpdateTabOne extends StatefulWidget {
   UpdateTabOne({super.key,required this.tabController,this.tourModelReceive,this.tourModel});
   TabController? tabController;

   TourModelReceive? tourModelReceive;
   TourModel? tourModel;
  @override
  State<UpdateTabOne> createState() => _UpdateTabOneState();
}

class _UpdateTabOneState extends State<UpdateTabOne> {

  final FocusNode _focusNode3 = FocusNode();
  bool _isFocused3 = false;
  List<File> imgs= [];

  TextEditingController textEditingDescription = TextEditingController();
  @override
  void initState() {
    super.initState();
    textEditingDescription.text = widget.tourModelReceive?.description ?? '';
    _focusNode3.addListener(() {
      setState(() {
        _isFocused3 = _focusNode3.hasFocus;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: LayoutBuilder(builder: (context,constraints){
          return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
              child: IntrinsicHeight(
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text("About Tour ",style: TextStyle(fontSize: 20,color: Colors.blue,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
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
                              controller: textEditingDescription,
                              focusNode: _focusNode3,
                              onChanged: (value) {
                                // Update the tour model description every time the text changes
                                setState(() {
                                  widget.tourModel?.description = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "talk about your tour...",
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
                        SizedBox(height: 25,),
                
                        BlocConsumer<TourCubit, TourState>(
                          listener: (context, state) {
                            if (state is TourImagesUpdated) {
                              setState(() {
                                imgs = state.images;  // Update the UI with the new list of images
                                widget.tourModel?.images = imgs;  // Update the tour model's images with the new images
                              });
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<TourCubit>(context).getImage();
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        color: Colors.blue[100],
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.burst_mode_outlined,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25,),
                                  imgs != null && imgs.isNotEmpty
                                      ? Wrap(
                                    spacing: 10, // Space between images horizontally
                                    runSpacing: 10, // Space between rows
                                    children: imgs.map((image) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Add your onTap functionality here
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context).size.width - 90) / 2, // Adjust width for 2 images per row
                                          height: 130,
                                          color: Colors.blue[100],
                                          alignment: Alignment.center,
                                          child: Image.file(
                                            image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                      : Wrap(
                                    spacing: 10, // Space between images horizontally
                                    runSpacing: 10, // Space between rows
                                    children: widget.tourModelReceive!.images.map((image) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Add your onTap functionality here
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context).size.width - 90) / 2, // Adjust width for 2 images per row
                                          height: 130,
                                          color: Colors.blue[100],
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            image.replaceAll("localhost", domain),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                
                                ],
                              ),
                            );
                          },
                        )
                        ,
                
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: SizedBox(
                            width: 100,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: (){
                                  print(widget.tourModel);
                                  widget.tabController!.animateTo(1,curve: Curves.easeOutQuart,duration: const Duration(milliseconds: 600));
                                },
                                style: const ButtonStyle(
                                  elevation: WidgetStatePropertyAll(0),
                                  backgroundColor: WidgetStatePropertyAll(mainColor),
                                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                                ),
                                child: Row(children: [Text("next"),SizedBox(width: 12,),Icon(Icons.arrow_forward_ios,color: Colors.white,size: 10,)],)
                            ),
                          ),
                        ),
                
                      ],
                    )
                ),
              ),
            ),
          );
      }),
    );
  }
}
