import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:flutter/foundation.dart';

class PlaceItem {
  final Place place;
  final Item item;

  PlaceItem({@required this.place, @required this.item})
      : assert(place != null),
        assert(item != null);
}
