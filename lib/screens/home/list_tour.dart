import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class ListTour extends StatefulWidget {
  const ListTour({super.key});

  @override
  State<ListTour> createState() => _ListTourState();
}

class _ListTourState extends State<ListTour> {

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchNode = FocusNode();
  Future<String> testfunction()async {
    Future.delayed(Duration(milliseconds: 1000));
    return "casablanca";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchNode.addListener(() => setState(() {}));

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchNode.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 13,
                      color: fourColor,
                    ),
                  ),
                ),
                const Text("Search",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'sf-ui',
                        fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {

                  },
                  icon: const Text("Cancel",style: TextStyle(fontFamily: 'sf-ui',color: Colors.red,fontSize: 16),),
                ),
              ],
            ),


          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _searchController,
              focusNode: _searchNode,
              decoration: InputDecoration(
                hintText: "search",
                filled: true,
                prefixIcon: Icon(Icons.search),
                fillColor: _searchNode.hasFocus ? const Color(0xffEBEBFF) : const Color(0xfff7f7f9),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
          ),

          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Search Places",
                  style: TextStyle(
                      fontFamily: 'sf-ui',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          SizedBox(height: 10,),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 3 / 4,
                    mainAxisExtent: 290,
                  ),
                  shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){},
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/img/nature.jpg",),
                          fit:BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.multiply)
                          ),
                          color: mainColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text("Azhar Tour",style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'sf-ui',fontWeight: FontWeight.bold),)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    "assets/img/locationIcon2.svg",
                                    width: 15,
                                    height: 15,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  FutureBuilder<String>(
                                    future: testfunction(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text(
                                          "Loading...",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'sf-ui',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          "Error",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'sf-ui',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.red[400],
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data ?? "Unknown",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'sf-ui',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.attach_money,
                                      size: 22,
                                      color: Colors.blueAccent,
                                    ),
                                    Text(
                                      "120",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'sf-ui',
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(
                                      "/person",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'sf-ui',
                                          color: Colors.grey[400],
                                          fontWeight:
                                          FontWeight.w400),
                                    )
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
