// ignore_for_file: file_names

class DWPNotification {
  final int id;
  final int userId;
  final String type; // mission_approved, mission_rejected, achievement_unlocked
  final String title;
  final String body;
  final Map<String, dynamic>? data; // mission_id, rejection_reason, etc
  final bool isRead;
  final DateTime sentAt;

  DWPNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    required this.sentAt,
  });

  factory DWPNotification.fromJson(Map<String, dynamic> json) {
    return DWPNotification(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      isRead: json['read_status'].toString() == '1',
      sentAt: DateTime.parse(json['sent_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'read_status': isRead ? 1 : 0,
      'sent_at': sentAt.toIso8601String(),
    };
  }

  // Helper methods
  bool get isMissionApproved => type == 'mission_approved';
  bool get isMissionRejected => type == 'mission_rejected';
  bool get isAchievementUnlocked => type == 'achievement_unlocked';

  int? get missionId => data?['mission_id'] != null
      ? int.tryParse(data!['mission_id'].toString())
      : null;

  String? get rejectionReason => data?['rejection_reason'];
  bool get canResubmit => data?['can_resubmit'] == true;
}
