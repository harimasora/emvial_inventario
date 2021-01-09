import 'package:emival_inventario/models/item.dart';

class Place {
  final String id;
  final String name;
  final List<Item> items;

  Place({this.id, this.name, this.items});

  factory Place.fromMap(Map data) {
    if (data == null) {
      return Place();
    }

    return Place(
      id: data['id'] as String ?? '',
      name: data['name'] as String ?? '',
      items: (data['items'] as List ?? <Map<dynamic, dynamic>>[])
          .map<Item>((dynamic v) => Item.fromMap(v as Map<dynamic, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'items': items.map((v) => v.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'id: $id, name: $name, items: $items';
  }
}
