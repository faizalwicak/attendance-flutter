class Quote {
  final int? id;
  final String? message;
  final bool? active;
  final int? schoolId;

  Quote({this.id, this.message, this.active, this.schoolId});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      message: json['message'],
      active: json['active'] == 1,
      schoolId: json['school_id'],
    );
  }
}
