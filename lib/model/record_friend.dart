import 'record.dart';
import 'grade.dart';
import 'school.dart';

class RecordFriend {
  final int? id;
  final String? username;
  final String? name;
  final List<Record?>? records;

  RecordFriend({this.id, this.username, this.name, this.records});

  factory RecordFriend.fromJson(Map<String, dynamic> json) {
    List<Record?> recordsList = [];
    if (json.containsKey('records')) {
      for(var i in json['records']) {
        recordsList.add(Record.fromJson(i));
      }
    }

    return RecordFriend(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      records: recordsList,
    );
  }
}
