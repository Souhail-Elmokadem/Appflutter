import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class LocationModel {

  LatLng? point;

  LocationModel( this.point);

  Map<String, dynamic> toJson() => {

      'latitude': point?.latitude,
      'longitude': point?.longitude,

  };

  static LocationModel fromJson(Map<String, dynamic> json) {
    return LocationModel(
      LatLng(json['latitude'], json['longitude']),
    );
  }
}
