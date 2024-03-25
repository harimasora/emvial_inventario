import 'package:freezed_annotation/freezed_annotation.dart';

import 'item.dart';
import 'system_log.dart';

part 'item_history.freezed.dart';
part 'item_history.g.dart';

@freezed
class ItemHistory with _$ItemHistory {
  const factory ItemHistory({
    required String imageUrl,
    required List<SystemLog> logs,
  }) = _ItemHistory;

  factory ItemHistory.fromJson(Map<String, dynamic> json) => _$ItemHistoryFromJson(json);
}
