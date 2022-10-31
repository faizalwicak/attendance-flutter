class School {
  final int? id;
  final String? name;
  final double? lat;
  final double? lng;
  final int? distance;
  final DateTime? clockIn;
  final DateTime? clockOut;

  School({
    this.id,
    this.name,
    this.lat,
    this.lng,
    this.distance,
    this.clockIn,
    this.clockOut,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
      distance: json['distance'],
      clockIn: null,
      clockOut: null,
    );
  }
}
