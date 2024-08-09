import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text("Edit Profile",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        // Add done action here
                      },
                      child: Text("Done"),
                      
                    )
                  ],
                ),
              ),
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                        'https://gale-s3-bucket.s3.eu-central-1.amazonaws.com/854ac909-1404-4785-bb63-4a8917e9edb7.jpeg',
                      ), // Use your asset image
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Add change picture functionality
                },
                child: Text(
                  "Change Picture",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 30),
              // First Name Field
              buildProfileField("First Name", "Med"),
              SizedBox(height: 20),
              // Last Name Field
              buildProfileField("Last Name", "L7WAY"),
              SizedBox(height: 20),
              // Location Field
              buildProfileField("Location", "k A R K"),
              SizedBox(height: 20),
              // Mobile Number Field
              buildProfileField("Mobile Number", "+212 611274199"),
            ],
          ),
        ),
      ),
    );
  }

  // Build a profile field
  Widget buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
              Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
