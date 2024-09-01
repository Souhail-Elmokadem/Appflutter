
class GuideModel{
  String? firstName;
  String? lastName;
  String? email;
  String? number;
  String? avatar;
  DateTime? createdAt;
  String? guideType;


  GuideModel(this.firstName,this.lastName,this.email,this.number,this.avatar,this.createdAt,this.guideType);

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'number': number,
    'avatar': avatar,
    'createdAt': createdAt?.toIso8601String(), // Ensure DateTime is serialized correctly
    'guideType': guideType,
  };
  static GuideModel fromJson(Map<String,dynamic> json){
    return  GuideModel(
      json['firstName'],
      json['lastName'],
      json['email'],
      json['number'],
      json['avatar'],
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null, // Parse DateTime
      json['guideType'],
    );
  }
}


