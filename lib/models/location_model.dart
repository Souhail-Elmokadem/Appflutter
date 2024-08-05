import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class LocationModel {
  String? name;
  LatLng? point;

  LocationModel(this.name, this.point);

  Map<String, dynamic> toJson() => {
    'name': name,
    'location':{
      'latitude': point?.latitude,
      'longitude': point?.longitude,
    }
  };

  static LocationModel fromJson(Map<String, dynamic> json) {
    return LocationModel(
      json['name'],
      LatLng(json['latitude'], json['longitude']),
    );
  }
}
