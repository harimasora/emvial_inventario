import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_log.freezed.dart';
part 'system_log.g.dart';

@freezed
class SystemLog with _$SystemLog {
  const factory SystemLog({
    @Default('') String text,
    @Default('') String itemId,
    @Default('') String placeId,
    @Default('') String userId,
    @ServerTimestampConverter() required DateTime timestamp,
  }) = _SystemLog;

  factory SystemLog.fromJson(Map<String, dynamic> json) => _$SystemLogFromJson(json);
}

class ServerTimestampConverter implements JsonConverter<DateTime, Object?> {
  const ServerTimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    try {
      if (json.runtimeType is Timestamp) {
        return Timestamp((json as Timestamp).seconds, json.nanoseconds).toDate();
      } else if (json.runtimeType == String) {
        return Timestamp.fromDate(DateTime.parse(json as String)).toDate();
      } else {
        return DateTime.now();
      }
    } catch (err) {
      return DateTime.now();
    }
  }

  @override
  Object? toJson(DateTime dateTime) => dateTime;
}
