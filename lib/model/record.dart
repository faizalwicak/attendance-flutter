import 'package:attendance_flutter/model/attend.dart';
import 'package:attendance_flutter/model/leave.dart';

class Record {
  final int? id;
  final int? userId;
  final String? date;
  final Attend? attend;
  final Leave? leave;
  final bool? isLeave;

  Record({
    this.id,
    this.userId,
    this.date,
    this.attend,
    this.leave,
    this.isLeave,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    Attend? attend;
    if (json.containsKey('attend') && json['attend'] != null) {
      attend = Attend.fromJson(json['attend']);
    }

    Leave? leave;
    if (json.containsKey('leave') && json['leave'] != null) {
      leave = Leave.fromJson(json['leave']);
    }

    return Record(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      attend: attend,
      leave: leave,
      isLeave: json['is_leave'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'attend': attend?.toJson(),
      'leave': leave?.toJson(),
      'is_leave': (isLeave ?? false) ? 1 : 0,
    };
  }
}
