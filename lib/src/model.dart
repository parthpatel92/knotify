class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final DateTime scheduleDate;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.scheduleDate,
  });

  // Convert to Map for sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'scheduleDate': scheduleDate.toIso8601String(),
    };
  }

  // Convert from Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      scheduleDate: DateTime.parse(map['scheduleDate']),
    );
  }
}
