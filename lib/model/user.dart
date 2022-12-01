import 'grade.dart';
import 'school.dart';

class User {
  final int? id;
  final String? username;
  final String? name;
  final School? school;
  final Grade? grade;
  final String? image;

  User({
    this.id,
    this.username,
    this.name,
    this.school,
    this.grade,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
      school: School.fromJson(json['school']),
      grade: Grade.fromJson(json['grade']),
    );
  }
}
