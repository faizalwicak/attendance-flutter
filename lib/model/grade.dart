class Grade {
  final int? id;
  final String? name;
  final int? grade;
  final int? schoolId;

  Grade({this.id, this.name, this.grade, this.schoolId});

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      name: json['name'],
      grade: json['grade'],
      schoolId: json['school_id'],
    );
  }
}
