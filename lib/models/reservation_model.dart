import 'package:guidanclyflutter/models/guide_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/models/visitor_model.dart';

class ReservationModel {
  int? id;
  DateTime? date;
  String? status;
  TourModelReceive? tour;
  VisitorModel? visitor;
  GuideModel? guide;

  ReservationModel({
    this.id,
    this.date,
    this.status,
    this.tour,
    this.visitor,
    this.guide,
  });

  // Serialization method
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date?.toIso8601String(), // Convert DateTime to ISO8601 string
    'status': status,
    'tour': tour?.toJson(), // Serialize TourModelReceive
    'visitor': visitor?.toJson(), // Serialize VisitorModel
    'guide': guide?.toJson(), // Serialize GuideModel
  };

  // Deserialization method
  static ReservationModel fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null, // Parse DateTime
      status: json['status'],
      tour: json['tour'] != null ? TourModelReceive.fromJson(json['tour']) : null,
      visitor: json['visitor'] != null ? VisitorModel.fromJson(json['visitor']) : null,
      guide: json['guide'] != null ? GuideModel.fromJson(json['guide']) : null,
    );
  }

  @override
  String toString() {
    return 'ReservationModel{id: $id, date: $date, status: $status, tour: $tour, visitor: $visitor, guide: $guide}';
  }
}
