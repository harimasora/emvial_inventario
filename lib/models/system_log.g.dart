// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemLogImpl _$$SystemLogImplFromJson(Map<String, dynamic> json) =>
    _$SystemLogImpl(
      text: json['text'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      placeId: json['placeId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      timestamp: const ServerTimestampConverter().fromJson(json['timestamp']),
    );

Map<String, dynamic> _$$SystemLogImplToJson(_$SystemLogImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'itemId': instance.itemId,
      'placeId': instance.placeId,
      'userId': instance.userId,
      'timestamp': const ServerTimestampConverter().toJson(instance.timestamp),
    };
