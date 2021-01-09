import 'dart:async';

import 'package:emival_inventario/constants/firestore_path.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

final inventoryStreamProvider = StreamProvider<List<Place>>((ref) {
  final db = ref.watch(databaseProvider);

  if (db == null) {
    return null;
  }

  return ref.watch(databaseProvider).streamPlaces();
});

final inventoryProvider = FutureProvider<List<Place>>((ref) async {
  final db = ref.watch(databaseProvider);

  if (db == null) {
    return null;
  }

  return ref.watch(databaseProvider).getPlaces();
});

class DatabaseService {
  final _service = FirestoreService.instance;

  Stream<List<Place>> streamPlaces() => _service.collectionStream(
        path: FirestorePath.places,
        builder: (data, documentId) => Place.fromMap(<dynamic, dynamic>{...data, 'id': documentId}),
      );

  Future<List<Place>> getPlaces() => _service.collectionGet(
        path: FirestorePath.places,
        builder: (data, documentId) => Place.fromMap(<dynamic, dynamic>{...data, 'id': documentId}),
      );

  Future<void> savePlace(Place place) =>
      _service.setData(path: '${FirestorePath.places}/${place.id}', data: place.toMap());

  Future<void> deletePlace(Place place) => _service.deleteData(path: '${FirestorePath.places}/${place.id}');

  Future<void> addPlace(Place place) => _service.collectionAdd(path: FirestorePath.places, data: place.toMap());
}
