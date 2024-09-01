import 'package:guidanclyflutter/models/location_model.dart';

class StopModel {
  String? name;
  LocationModel? location;

  StopModel({this.name, this.location});

  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location?.toJson(),
  };

  static StopModel fromJson(Map<String, dynamic> json) {
    return StopModel(
      name: json['name'], // Nullable String
      location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
    );
  }

  @override
  String toString() {
    return 'StopModel{name: $name, location: $location}';
  }
}
