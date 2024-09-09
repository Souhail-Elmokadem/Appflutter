import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class UpdateTabTwo extends StatefulWidget {
  TabController? tabController;

  TourModel? tourModel;
  TourModelReceive? tourModelReceive;
  UpdateTabTwo({super.key,this.tabController,this.tourModelReceive,this.tourModel});

  @override
  State<UpdateTabTwo> createState() => _UpdateTabTwoState();
}

class _UpdateTabTwoState extends State<UpdateTabTwo> {


  final FocusNode _focusNode3 = FocusNode();
  bool _isFocused3 = false;
  final FocusNode _focusNode4 = FocusNode();
  bool _isFocused4 = false;


  TextEditingController textEditingPrice = TextEditingController();
  TextEditingController textEditingName = TextEditingController();
  @override
  void initState() {
    super.initState();

    _focusNode3.addListener(() {
      setState(() {
        _isFocused3 = _focusNode3.hasFocus;
      });
    });
    _focusNode4.addListener(() {
      setState(() {
        _isFocused4 = _focusNode4.hasFocus;
      });
    });
    textEditingName.text=widget.tourModel?.tourTitle??"";
    textEditingPrice.text=widget.tourModel?.price.toString()??"";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context,constraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
            minHeight: constraints.maxHeight
          ),
          child: IntrinsicHeight(
           child: Container(
             width: double.infinity,
             height: double.infinity,
             decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
             ),

             child: Column(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 SizedBox(
                   height: 50,
                 ),
                 Container(
                   width: double.infinity,
                   padding: EdgeInsets.symmetric(horizontal: 30.0),
                   child: Text("Tour Name",style: TextStyle(fontSize: 20,color: Colors.blue,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
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
                       controller: textEditingName,
                       focusNode: _focusNode4,
                       onChanged: (val){
                         widget.tourModel?.tourTitle=val;

                       },
                       decoration: InputDecoration(

                         hintText: "name",
                         filled: true,
                         fillColor: _isFocused4
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
                 SizedBox(height: 30,),
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
                       onChanged: (val){
                         widget.tourModel?.price=double.tryParse(val);

                       },
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
                 SizedBox(height: 20,),
                 Padding(
                   padding: const EdgeInsets.all(25),
                   child: SizedBox(
                     width: 100,
                     height: 40,
                     child: ElevatedButton(
                         onPressed: (){

                           widget.tabController!.animateTo(2,curve: Curves.easeOutQuart,duration: const Duration(milliseconds: 600));
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
             ),
           ),
          ),
          ),
        );
      }),
    );
  }
}
