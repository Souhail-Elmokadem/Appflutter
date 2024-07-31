import 'package:flutter/material.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              margin: EdgeInsets.fromLTRB(10, 15, 10, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  icon: Icon(Icons.arrow_back),
                ),

                  Text("Profile", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                ],
              ),
            ),
            // Profile Details
            Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://gale-s3-bucket.s3.eu-central-1.amazonaws.com/854ac909-1404-4785-bb63-4a8917e9edb7.jpeg',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Med L7way",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_sharp),
                            Text(
                        "Casablanca",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                          ]
                      ),
                    
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("Visited Place", style: TextStyle(fontSize: 16, color: Colors.grey)),
                            Text("1k+", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Tours", style: TextStyle(fontSize: 16, color: Colors.grey)),
                            Text("1k+", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Review Section
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text("Previous Tours",
                          style: 
                          TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                          ReviewCard(
                            name: "Tour 1",
                            date: "08-10-20",
                            review:
                                "Visiting Marrakech Was a good Place...",
                          ),
                          SizedBox(height: 10),
                          ReviewCard(
                            name: "Tour 2",
                            date: "08-10-20",
                            review:
                                "Visiting Marrakech Was a good Place...",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Schedule Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Next Tour",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Guide Name",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sep, 2020",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Appointment Details
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Location"),
                            Text("Tour Location"),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("View More Details ...",
                          style: TextStyle(color:Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final String review;

  ReviewCard({required this.name, required this.date, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(date, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 10),
          Text(review, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
