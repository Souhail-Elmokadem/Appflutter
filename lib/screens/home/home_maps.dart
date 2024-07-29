import 'package:flutter/material.dart';
import 'package:guidanclyflutter/screens/widgets/maps_screen.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class HomeMaps extends StatefulWidget {
  const HomeMaps({super.key});

  @override
  State<HomeMaps> createState() => _HomeMapsState();
}

class _HomeMapsState extends State<HomeMaps> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
  }

  void _moveSheetToBottom() {
    // Use the DraggableScrollableActuator to notify the DraggableScrollableSheet
    DraggableScrollableActuator.reset(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map section with GestureDetector
          Positioned.fill(
            child: GestureDetector(
              onTap: _moveSheetToBottom,
              child: MapsScreen(),
            ),
          ),
          //DraggableScrollableSheet for the bottom container
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.3, // Initial size of the sheet
              minChildSize: 0.1,     // Minimum size of the sheet
              maxChildSize: 0.5,     // Maximum size of the sheet
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                          SizedBox(height: 16),
                          Text(
                            "Tour Details",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Divider(color: Colors.grey[300]),
                          SizedBox(height: 8),
                          _buildDetailRow(Icons.description, "Description: Explore the city with a guide."),
                          _buildDetailRow(Icons.location_on, "Highlights: Famous landmarks, hidden gems."),
                          _buildDetailRow(Icons.access_time, "Duration: 3 hours"),
                          _buildDetailRow(Icons.attach_money, "Price: \$30"),
                          _buildDetailRow(Icons.person, "Guide: John Doe (5-star rating)"),
                          _buildDetailRow(Icons.star, "Reviews: ★★★★★ (150 reviews)"),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle booking
                              },
                              child: Text('Book Now'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Add more tour details or any other widgets here
                        ],
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
