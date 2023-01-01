import 'grade.dart';
import 'school.dart';
import 'link.dart';
import 'quote.dart';

class User {
  final int? id;
  final String? username;
  final String? name;
  final School? school;
  final Grade? grade;
  final String? image;
  final int? notifications;
  final Quote? quote;
  final List<Link>? links;

  User({
    this.id,
    this.username,
    this.name,
    this.school,
    this.grade,
    this.image,
    this.notifications,
    this.quote,
    this.links,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Link> links = [];
    if (json['link'] != null) {
      for (var i in json['link']) {
        links.add(Link.fromJson(i));
      }
    }
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      image: json['image'],
      school: School.fromJson(json['school']),
      grade: Grade.fromJson(json['grade']),
      notifications: json['notifications'],
      quote: Quote.fromJson(json['quote']),
      links: links,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'image': image,
      'school': school?.toJson(),
      'grade': grade?.toJson(),
      'notifications': notifications,
      'quote': quote?.toString(),
      'link': links?.toString(),
    };
  }
}
