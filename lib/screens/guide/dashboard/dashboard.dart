import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/guide/guide_cubit.dart';
import 'package:guidanclyflutter/cubit/guide/guide_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour_details.dart';
import 'package:guidanclyflutter/screens/guide/update_tour/update_tour.dart';
import 'package:guidanclyflutter/screens/profile/profile_screen_guide.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:page_transition/page_transition.dart';

class Dashboard extends StatefulWidget {
   Dashboard({super.key,this.guideModel});

  GuideModel? guideModel;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    super.initState();
    // Fetch tours data when initializing the screen
    context.read<GuideCubit>().getToursByGuide();
  }

  @override
  void didUpdateWidget(Dashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.guideModel != oldWidget.guideModel) {
      // Reset or update state when guideModel changes
      context.read<GuideCubit>().getToursByGuide();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                //Navigator.push(context, PageTransition(child: ProfileScreen(userModel: ,), type: PageTransitionType.fade));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10,35,35,0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(widget.guideModel?.avatar! != null ? widget.guideModel!.avatar!.replaceAll("localhost", domain) : ""),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 60, 0),
                      child: Text(
                        widget.guideModel!.firstName!,
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_sharp)
                  ],
                ),
              ),
            ),

            // Divider(height: 1, color: Colors.black12),
            ListView(
              padding: EdgeInsets.only(top: 30),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.add_location_alt_outlined),
                  title: Text('Create Tour',style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'sf-ui',),),
                  onTap: () {
                     Navigator.push(context, PageTransition(child: CreateTourDetails(guideModel: widget.guideModel != null?widget.guideModel:GuideModel("", "", "", "", "", DateTime.now(), ""),), type: PageTransitionType.fade,curve: Curves.easeInOut,duration: Duration(milliseconds: 600)));
                  },
                ),
              ],
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 35,horizontal: 15),
              height: 300,
              color: mainColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          _key.currentState!.openDrawer();
                        },
                      icon:const Icon(Icons.sort,color: Colors.white,size: 40) ,
                      ),
                      Text("guidancly",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'sf-ui',fontSize: 22),),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, PageTransition(child: ProfileScreenGuide(guideModel: widget.guideModel), type: PageTransitionType.rightToLeftJoined,childCurrent: Dashboard(guideModel: widget.guideModel,), curve: Curves.easeOut,duration: Duration(milliseconds: 400)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.guideModel?.avatar! != null ? widget.guideModel!.avatar!.replaceAll("localhost", domain) : ""),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Hi ${widget.guideModel!.firstName} !",style: const TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),))
                  ,Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Created at: ${_format(widget.guideModel!.createdAt!)}",style: const TextStyle(color: Colors.white54,fontSize: 15,fontFamily: 'sf-ui',fontWeight: FontWeight.w400),))
                ],
              ),
            ),
            BlocConsumer<GuideCubit, GuideState>(
              listener: (context, state) {},
              builder: (context, state) {


                if (state is GuideStateSuccess) {
                  return Container(
                    margin: const EdgeInsets.only(top: 200),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: 600,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.9,
                        mainAxisSpacing: 25,
                      ),
                      shrinkWrap: true,

                      itemCount: state.tours.length, // Ensure itemCount is not nullable
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: UpdateTour(tourModelReceive: state.tours[index]),
                                type: PageTransitionType.rightToLeftWithFade,
                                curve: Curves.easeOut,
                              ),
                            );

                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.orangeAccent.withOpacity(0.5), BlendMode.multiply),
                                image: NetworkImage(state.tours[index].images[0].replaceAll("localhost", domain))),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text(state.tours[index]!.tourTitle!,style: TextStyle(fontSize: 25,color: Colors.white,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
                                          Row(
                                            children: [
                                            Icon(Icons.star,color: Colors.white,size: 18,),
                                            Text("4.7",style: TextStyle(fontSize: 13,color: Colors.white,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),),
                                          ],)
                                      ],),
                                      Row(children: [
                                        Expanded(child: Text(state.tours[index]!.description!,style: TextStyle(fontSize: 15,color: Colors.white,fontFamily: 'sf-ui',fontWeight: FontWeight.w100),)),
                                      ],)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                    Text("click to update",style: TextStyle(fontSize: 13,color: Colors.white,fontFamily: 'sf-ui',fontWeight: FontWeight.bold))
                                   ,SizedBox(width: 10,),Icon(Icons.east_outlined,color: Colors.white,size: 15,)
                                    ],)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is GuideStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GuideStateFailed) {
                  return const Center(
                    child: Text('Failed to load tours'),
                  );
                } else {
                  return const Center(
                    child: Text('Welcome! Please wait while we load your tours.'),
                  );
                }
              },
            )

          ],
        ),
      ),

    );
  }
  String _format(DateTime date){
    return date.toString().substring(0,10);
    // return "${date.year}-${date.month}-${date.day}";
  }
}
