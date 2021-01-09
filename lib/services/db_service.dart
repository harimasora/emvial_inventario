import 'dart:async';

import 'package:emival_inventario/constants/firestore_path.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

final inventoryProvider = StreamProvider<List<Place>>((ref) {
  final db = ref.watch(databaseProvider);

  if (db == null) {
    return null;
  }

  return ref.watch(databaseProvider).streamPlaces();
});

class DatabaseService {
  final _service = FirestoreService.instance;

  Stream<List<Place>> streamPlaces() => _service.collectionStream(
        path: FirestorePath.places,
        builder: (data, documentId) => Place.fromMap(data),
      );
}
