import 'grade.dart';
import 'school.dart';

class User {
  final int? id;
  final String? username;
  final String? name;
  final School? school;
  final Grade? grade;

  User({this.id, this.username, this.name, this.school, this.grade});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      school: School.fromJson(json['school']),
      grade: Grade.fromJson(json['grade']),
    );
  }
}
