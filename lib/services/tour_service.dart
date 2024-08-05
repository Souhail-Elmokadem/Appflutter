import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:guidanclyflutter/models/tour_model.dart';

class TourService {
  final String apiUrl = 'YOUR_API_ENDPOINT'; // Replace with your API endpoint

  Future<bool> saveTour(TourModel tour) async {
    print("======================================");
    print(tour.toJson());
    print("======================================");

    try {
      var body = json.encode(tour.toJson());
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to save tour: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saving tour: $e');
      return false;
    }
  }
}
