// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemHistoryImpl _$$ItemHistoryImplFromJson(Map<String, dynamic> json) =>
    _$ItemHistoryImpl(
      imageUrl: json['imageUrl'] as String,
      logs: (json['logs'] as List<dynamic>)
          .map((e) => SystemLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ItemHistoryImplToJson(_$ItemHistoryImpl instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'logs': instance.logs.map((e) => e.toJson()).toList(),
    };
