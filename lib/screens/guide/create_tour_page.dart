import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/screens/guide/create_tour.dart';

class CreateTourPage extends StatefulWidget {
  @override
  _CreateTourPageState createState() => _CreateTourPageState();
}

class _CreateTourPageState extends State<CreateTourPage> {
  final CreateTour createTour = CreateTour();
  TextEditingController _tourNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createTour.initializeCurrentLocation().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Tour"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save tour logic
            },
          ),
        ],
      ),
      body: createTour.currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _tourNameController,
              decoration: InputDecoration(
                labelText: 'Tour Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(createTour.currentLocation!.latitude!, createTour.currentLocation!.longitude!),
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    createTour.mapController.complete(controller);
                  },
                  onTap: (position) {
                    setState(() {
                      createTour.addWaypoint(position);
                    });
                  },
                  markers: createTour.getWaypoints()
                      .map((point) => Marker(markerId: MarkerId(point.toString()), position: point))
                      .toSet(),
                  polylines: createTour.getPolylines().toSet(),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: ElevatedButton(
                    onPressed: () async {
                      await createTour.generateRoute();
                      setState(() {});
                    },
                    child: Text('Generate Route'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
