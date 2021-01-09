class Item {
  final String id;
  final String name;

  Item({this.id, this.name});

  factory Item.fromMap(Map data) {
    if (data == null) {
      return Item();
    }

    return Item(
      id: data['id'] as String ?? '',
      name: data['name'] as String ?? '',
    );
  }

  @override
  String toString() {
    return 'id: $id, name: $name';
  }
}
