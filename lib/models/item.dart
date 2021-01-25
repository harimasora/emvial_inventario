class Item {
  final String id;
  final String name;
  final String imageUrl;

  Item({this.id, this.name, this.imageUrl});

  factory Item.fromMap(Map data) {
    if (data == null) {
      return Item();
    }

    return Item(
      id: data['id'] as String,
      name: data['name'] as String ?? '',
      imageUrl: data['imageUrl'] as String ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  Item copyWith({String id, String name, String imageUrl}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'id: $id, name: $name';
  }
}
