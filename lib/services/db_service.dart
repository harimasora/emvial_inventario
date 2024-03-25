import 'dart:async';

import 'package:emival_inventario/constants/firestore_path.dart';
import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/system_log.dart';

final databaseProvider = Provider<DatabaseService>((ref) => DatabaseService());

final inventoryStreamProvider = StreamProvider<List<Place>>((ref) {
  return ref.watch(databaseProvider).streamPlaces();
});

final logsStreamProvider = StreamProvider<List<SystemLog>>((ref) {
  return ref.watch(databaseProvider).streamLogs();
});

final inventoryProvider = FutureProvider<List<Place>>((ref) async {
  return ref.watch(databaseProvider).getPlaces();
});

class DatabaseService {
  final _service = FirestoreService.instance;

  String get randomDocumentId => _service.randomDocumentId;

  Stream<List<Place>> streamPlaces() => _service.collectionStream(
        path: FirestorePath.places,
        builder: (data, documentId) => Place.fromJson(<String, dynamic>{...data, 'id': documentId}),
      );

  Stream<List<SystemLog>> streamLogs() => _service.collectionStream(
        path: FirestorePath.logs,
        builder: (data, documentId) => SystemLog.fromJson(<String, dynamic>{...data}),
        queryBuilder: (query) => query.orderBy('timestamp', descending: true),
      );

  Future<List<Place>> getPlaces() => _service.collectionGet(
        path: FirestorePath.places,
        builder: (data, documentId) => Place.fromJson(<String, dynamic>{...data, 'id': documentId}),
      );

  Future<void> removeItemFromPlace(Place place, Item item) {
    final placeToSave = place..items.remove(item);
    return _service.setData(
      path: '${FirestorePath.places}/${place.id}',
      data: placeToSave.toJson(),
    );
  }

  Future<void> savePlaceItem(PlaceItem placeItem) {
    // Remove previous item
    placeItem.place.items.removeWhere((item) => item.id == placeItem.item.id);
    // Add new data
    placeItem.place.items.add(placeItem.item);
    // Save place
    return savePlace(placeItem.place);
  }

  Future<void> deleteImage(PlaceItem placeItem) {
    final FirebaseStorage _storage =
        FirebaseStorage.instanceFor(bucket: 'gs://emival-engenharia-inventario.appspot.com');

    return Future.wait([
      _storage.ref().child('tools/${placeItem.item.id}.png').delete(),
      savePlaceItem(PlaceItem(place: placeItem.place, item: placeItem.item.copyWith(imageUrl: ''))),
    ]);
  }

  Future<void> savePlace(Place place) =>
      _service.setData(path: '${FirestorePath.places}/${place.id}', data: place.toJson());

  Future<void> deletePlace(Place place) => _service.deleteData(path: '${FirestorePath.places}/${place.id}');

  Future<void> addPlace(Place place) => _service.collectionAdd(path: FirestorePath.places, data: place.toJson());
}
