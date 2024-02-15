import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_item.freezed.dart';
part 'place_item.g.dart';

@freezed
class PlaceItem with _$PlaceItem {
  const factory PlaceItem({
    required Place place,
    required Item item,
  }) = _PlaceItem;

  factory PlaceItem.fromJson(Map<String, dynamic> json) => _$PlaceItemFromJson(json);
}
