import 'dart:convert';
import 'dart:io';

import 'package:guidanclyflutter/models/stop_model.dart'; // Import StopModel

class TourModel {
  int id;
  String? tourTitle;
  StopModel? depart;
  String? description;
  List<StopModel>? stops; // Updated to use StopModel
  int estimatedTime;
  int distance;
  double? price; // Nullable to handle potential null values
  List<File>? images; // Nullable to handle potential null values

  TourModel(this.id,this.tourTitle, this.depart, this.description,this.estimatedTime,this.distance, this.stops, this.price, this.images);

  Map<String, dynamic> toJson() => {
    'id':id,
    'title': tourTitle,
    'description': description,
    'depart': depart?.toJson(),
    'estimatedTime':estimatedTime,
    'distance':distance,
    'stops': stops?.map((stop) => stop.toJson()).toList(),
    'price': price,

    'images': images?.map((image) => base64Encode(image.readAsBytesSync())).toList(), // Encode images to Base64
  };

  static TourModel fromJson(Map<String, dynamic> json) {
    return TourModel(
      json['id'],
      json['title'], // Corrected key from 'tourTitle' to 'title'
      json['depart'] != null ? StopModel.fromJson(json['depart']) : null, // Handle depart as StopModel
      json['description'],
      json['estimatedTime'],
      json['distance'],
      (json['stops'] as List<dynamic>?)
          ?.map((stop) => StopModel.fromJson(stop))
          .toList(),
      json['price'], // Parse the price
      (json['images'] as List<dynamic>?)
          ?.map((image) => File.fromRawPath(base64Decode(image))) // Decode Base64 to File
          .toList(),
    );
  }

  @override
  String toString() {
    return 'TourModel{tourTitle: $tourTitle, depart: $depart, description: $description, stops: $stops, price: $price, images: $images}';
  }
}
