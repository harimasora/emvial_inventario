import 'package:emival_inventario/models/item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.g.dart';
part 'place.freezed.dart';

@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    @Default('') String name,
    @Default([]) List<Item> items,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
