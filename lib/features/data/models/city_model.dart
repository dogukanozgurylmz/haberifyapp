class CityModel {
  final String id;
  final String countryId;
  final String city;

  CityModel({
    required this.id,
    required this.countryId,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'country_id': countryId,
      'city': city,
    };
  }

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      countryId: json['country_id'] as String,
      city: json['city'] as String,
    );
  }
}
