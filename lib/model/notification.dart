class MNotification {
  final int? id;
  final String? title;
  final String? message;
  final int? schoolId;

  MNotification({this.id, this.message, this.title, this.schoolId});

  factory MNotification.fromJson(Map<String, dynamic> json) {
    return MNotification(
      id: json['id'],
      message: json['message'],
      title: json['title'],
      schoolId: json['school_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'title': title,
      'school_id': schoolId,
    };
  }
}
