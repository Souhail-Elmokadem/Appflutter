import 'package:guidanclyflutter/models/tour_model_receive.dart';

class VisitorModel{
  String? firstName;
  String? lastName;
  String? email;
  String? number;
  String? avatar;
  DateTime? createdAt;
  TourModelReceive? currentTour;
  VisitorModel(
  this.firstName,
  this.lastName,
  this.email,
  this.number,
  this.avatar,
  this.createdAt,
  this.currentTour);
  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'number': number,
    'avatar': avatar,
    'createdAt': createdAt?.toIso8601String(), // Ensure DateTime is serialized correctly
    'currentTour': currentTour?.toJson(), // Serialize currentTour to JSON
  };
  static VisitorModel fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      json['firstName'],
      json['lastName'],
      json['email'],
      json['number'],
      json['avatar'],
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null, // Parse DateTime
      json['currentTour'] != null
          ? TourModelReceive.fromJson(json['currentTour'])
          : null, // Deserialize currentTour from JSON
    );
  }

}