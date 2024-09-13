import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/services/message_dialog_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class CreateTourDetails extends StatefulWidget {

  GuideModel? guideModel;
  CreateTourDetails({super.key,this.guideModel});

  @override
  State<CreateTourDetails> createState() => _CreateTourDetailsState();
}

class _CreateTourDetailsState extends State<CreateTourDetails> {

  final FocusNode _focusNode3 = FocusNode();
  bool _isFocused3 = false;
  MessageDialogService messageDialogService = MessageDialogService();


  TextEditingController textEditingDescription = TextEditingController();
  @override
  void initState() {
    super.initState();

    _focusNode3.addListener(() {
      setState(() {
        _isFocused3 = _focusNode3.hasFocus;
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
                if(textEditingDescription.text.length<25 && textEditingDescription.text.length>150){
                  messageDialogService.showErrorDialog(context, "About Tour field must have at least 25 characters and 150 max!");
                }else if(BlocProvider.of<TourCubit>(context).listimages == null){
                  messageDialogService.showErrorDialog(context, "Please upload the image file !");

                }
                else{

                  Navigator.pushNamed(context,'/createTourCotes',arguments: {'about': textEditingDescription.text,'images':BlocProvider.of<TourCubit>(context).listimages,'guide':widget.guideModel != null?widget.guideModel:GuideModel("", "", "", "", "", DateTime.now(), "")} );

                }
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
             SizedBox(
               height: 35,
             ),
             Container(
               width: double.infinity,
               padding: EdgeInsets.symmetric(horizontal: 30.0),
               child: const Text("Images",style: TextStyle(fontSize: 20,color: Colors.blue,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
             ),
             SizedBox(
               height: 20,
             ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 30),
               child: BlocConsumer<TourCubit, TourState>(
                 listener: (context,state){
                   if(state is TourImagesFailedSize){
                     messageDialogService.showErrorDialog(context, state.error);
                   }
                 },
                 builder: (context, state) {
                   final images = (state is TourImagesUpdated) ? state.images : null;
                   return Column(
                     children: [
                       images == null
                           ? GestureDetector(
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
                               Icons.add,
                               color: Colors.blueAccent,
                             ),
                           ),
                         ),
                       )
                           : GestureDetector(
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
                       SizedBox(height: 50),
                       images != null && images.isNotEmpty
                           ? Wrap(
                         spacing: 10, // Space between images horizontally
                         runSpacing: 10, // Space between rows
                         children: images.map((image) {
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
                           : Container(),
                       SizedBox(height: 25),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [],
                       ),
                     ],
                   );
                 },
               ),
             )



           ],
        ),
      ),
    );
  }
}
