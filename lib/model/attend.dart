class Attend {
  final int? id;
  final int? recordId;
  final String? clockInTime;
  final String? clockOutTime;
  final String? clockInLat;
  final String? clockInLng;
  final String? clockOutLat;
  final String? clockOutLng;
  final String? clockInStatus;

  Attend({
    this.id,
    this.recordId,
    this.clockInTime,
    this.clockOutTime,
    this.clockInLat,
    this.clockInLng,
    this.clockOutLat,
    this.clockOutLng,
    this.clockInStatus,
  });

  factory Attend.fromJson(Map<String, dynamic> json) {
    return Attend(
      id: json['id'],
      recordId: json['record_id'],
      clockInTime: json['clock_in_time'],
      clockOutTime: json['clock_out_time'],
      clockInLat: json['clock_in_lat'],
      clockInLng: json['clock_in_lng'],
      clockOutLat: json['clock_out_lat'],
      clockOutLng: json['clock_out_lng'],
      clockInStatus: json['clock_in_status'],
    );
  }
}