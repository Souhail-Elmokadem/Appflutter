import 'package:guidanclyflutter/models/location_model.dart';

class TourModel {
  String? tourTitle;
  LocationModel? depart;
  List<LocationModel>? stops;

  TourModel(this.tourTitle, this.depart, this.stops);

  Map<String, dynamic> toJson() => {
    'title': tourTitle,
    'depart': depart?.toJson(),
    'stops': stops?.map((stop) => stop.toJson()).toList(),
  };

  static TourModel fromJson(Map<String, dynamic> json) {
    return TourModel(
      json['tourTitle'],
      json['depart'] != null ? LocationModel.fromJson(json['depart']) : null,
      (json['stops'] as List<dynamic>?)
          ?.map((stop) => LocationModel.fromJson(stop))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'TourModel{tourTitle: $tourTitle, depart: $depart, stops: $stops}';
  }
}
