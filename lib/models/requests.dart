class Request {
  String articleId;
  String ownerId;
  String status;
  DateTime dateTime;

  Request({
    required this.articleId,
    required this.ownerId,
    required this.status,
    required this.dateTime,
  });

  // Convert Request object to JSON
  Map<String, dynamic> toJson() {
    return {
      'articleId': articleId,
      'ownerId': ownerId,
      'status': status,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create Request object from JSON
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      articleId: json['articleId'],
      ownerId: json['ownerId'],
      status: json['status'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
