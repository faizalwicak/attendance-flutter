class Absent {
  final int? id;
  final int? userId;
  final String? type;
  final String? description;
  final String? status;
  final String? date;

  Absent({
    this.id,
    this.userId,
    this.type,
    this.description,
    this.status,
    this.date,
  });

  factory Absent.fromJson(Map<String, dynamic> json) {
    return Absent(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      description: json['description'],
      status: json['status'],
      date: json['date'],
    );
  }
}
