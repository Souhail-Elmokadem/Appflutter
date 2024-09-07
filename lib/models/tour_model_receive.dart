import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/models/stop_model.dart';

class TourModelReceive {
  int id;
  String? tourTitle;
  StopModel? depart;
  String? description;
  GuideModel? guide;
  int estimatedTime;
  int distance;
  List<StopModel>? stops; // Updated to use StopModel
  double price;
  List<String> images;
  int numberOfVisitors;// List of Base64 encoded images

  TourModelReceive(
      this.id,
      this.tourTitle,
      this.depart,
      this.description,
      this.estimatedTime,
      this.distance,
      this.stops,
      this.guide,
      this.price,
      this.images,
      this.numberOfVisitors
      );

  Map<String, dynamic> toJson() => {
    'id':id,
    'title': tourTitle,
    'description': description,
    'depart': depart?.toJson(),
    'estimatedTime':estimatedTime,
    'distance':distance,
    'stops': stops?.map((stop) => stop.toJson()).toList(),
    'guide': guide?.toJson(),
    'price': price,
    'images': images,
    'numberOfVisitors':numberOfVisitors
  };

  static TourModelReceive fromJson(Map<String, dynamic> json) {
    return TourModelReceive(
      json['id'], // Corrected key from id
      json['title'], // Corrected key from 'tourTitle' to 'title'
      json['depart'] != null ? StopModel.fromJson(json['depart']) : null, // Handle depart as StopModel
      json['description'],
      json['estimatedTime'],
      json['distance'],
      (json['stops'] as List<dynamic>?)
          ?.map((stop) => StopModel.fromJson(stop))
          .toList(),
      json['guide'] != null ? GuideModel.fromJson(json['guide']) : null, // Handle guide from JSON
      json['price'] != null ? json['price'].toDouble() : 0.0, // Convert price to double
      (json['images'] as List<dynamic>?)
          ?.map((image) => image.toString()) // Ensure the images are stored as strings
          .toList() ??
          [],
      json['numberOfVisitors'] ?? 0
    );
  }

  @override
  String toString() {
    return 'TourModelReceive{tourTitle: $tourTitle, depart: $depart, description: $description, guide: $guide, stops: $stops, price: $price, images: $images}';
  }
}
