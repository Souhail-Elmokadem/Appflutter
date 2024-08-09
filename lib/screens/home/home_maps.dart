import 'package:flutter/material.dart';
import 'package:guidanclyflutter/screens/Settings/settings_screen.dart';
import 'package:guidanclyflutter/screens/profile/profile_screen.dart';
import 'package:guidanclyflutter/screens/widgets/maps_screen.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class HomeMaps extends StatefulWidget {
  const HomeMaps({super.key});

  @override
  State<HomeMaps> createState() => _HomeMapsState();
}

class _HomeMapsState extends State<HomeMaps> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
    bool isSheetBottom=false;
  @override
  void initState() {
    super.initState();
  }

  void _moveSheetToBottom() {
    _sheetController.animateTo(0.1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    isSheetBottom=true;
  }
  void _moveSheetToTop() {
    _sheetController.animateTo(0.4, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    isSheetBottom=false;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        'https://gale-s3-bucket.s3.eu-central-1.amazonaws.com/854ac909-1404-4785-bb63-4a8917e9edb7.jpeg',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 60, 0),
                    child: Text(
                      "Med l7way",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right_sharp)
                ],
              ),
            ),
            ListView(
              padding: EdgeInsets.only(top: 30),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                      leading: Icon(Icons.person_pin),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                        );
                      },
                ),
                Divider(height: 1, color: Colors.black12),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {},
                ),
              ],
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingScreen()),
                        );
                      },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _moveSheetToBottom,
              child: MapsScreen(onMapTap: _moveSheetToBottom),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Builder(
              builder: (context) => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Icon(Icons.directions, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Search in Guidancly Maps",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.4,
              minChildSize: 0.12,
              maxChildSize: 0.4,
              builder: (context, scrollController) {
                return GestureDetector(
                  onTap: (){
                    if(!isSheetBottom) {
                      _moveSheetToBottom();
                    }else{
                      _moveSheetToTop();
                    }
                  },
                  child: Container(

                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Find a Tour",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Where do you want to go?",
                                      prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Offer your fare",
                                      prefixIcon: Icon(Icons.attach_money, color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle tour search
                                        },
                                        child: Text('Find a Tour',style: TextStyle(color: Colors.white),),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainColor,

                                          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle tour search
                                        },
                                        child: Icon(Icons.settings_outlined,color: Colors.white,size: 20,),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainColor,

                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            // Add more tour details or any other widgets here
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
