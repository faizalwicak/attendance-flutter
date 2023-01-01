import 'package:attendance_flutter/model/quote.dart';

class School {
  final int? id;
  final String? name;
  final double? lat;
  final double? lng;
  final int? distance;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String? image;
  final String? imageBackground;

  School({
    this.id,
    this.name,
    this.lat,
    this.lng,
    this.distance,
    this.clockIn,
    this.clockOut,
    this.image,
    this.imageBackground,
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
      image: json['image'],
      imageBackground: json['image_background'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'distance': distance,
      'image': image,
      'image_background': imageBackground,
    };
  }
}
