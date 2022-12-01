class Leave {
  final int? id;
  final int? recordId;
  final String? type;
  final String? description;
  final String? leaveStatus;

  Leave({
    this.id,
    this.recordId,
    this.type,
    this.description,
    this.leaveStatus,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'],
      recordId: json['record_id'],
      type: json['type'],
      description: json['description'],
      leaveStatus: json['leave_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'record_id': recordId,
      'type': type,
      'description': description,
      'leaveStatus': leaveStatus
    };
  }
}
