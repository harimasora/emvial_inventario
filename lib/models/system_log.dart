import 'package:cloud_firestore/cloud_firestore.dart';

class SystemLog {
  final String text;
  final String itemId;
  final String placeId;
  final String userId;
  final DateTime timestamp;

  SystemLog({this.text, this.itemId, this.placeId, this.userId, this.timestamp});

  factory SystemLog.fromMap(Map data) {
    if (data == null) {
      return SystemLog();
    }

    return SystemLog(
      text: data['text'] as String ?? '',
      itemId: data['itemId'] as String ?? '',
      placeId: data['placeId'] as String ?? '',
      userId: data['userId'] as String ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'itemId': itemId,
      'placeId': placeId,
      'userId': userId,
      'timestamp': timestamp,
    };
  }

  SystemLog copyWith({String text, String itemId, String placeId, String userId, DateTime timestamp}) {
    return SystemLog(
      text: text ?? this.text,
      itemId: itemId ?? this.itemId,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'text: $text, timestamp: $timestamp, itemId: $itemId, placeId: $placeId, userId: $userId';
  }
}
