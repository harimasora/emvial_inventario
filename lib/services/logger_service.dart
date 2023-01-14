import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/models/system_log.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/item.dart';
import 'firestore_service.dart';

class LoggerService {
  final _service = FirestoreService.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> _currentUser() async => _auth.currentUser?.displayName ?? _auth.currentUser?.email ?? 'NULL';

  String get randomDocumentId => _service.randomDocumentId;
  String get _formattedDate {
    final date = DateTime.now();
    return '[${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year.toString()} ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}]';
  }

  Future<void> logAddItem(Item item, Place place) async {
    final username = await _currentUser();
    final itemName = item.name;
    final placeName = place.name;
    final systemLog = SystemLog(
      text: '$_formattedDate $username ADICIONOU $itemName em $placeName',
      itemId: item.id,
      placeId: place.id,
      userId: _auth.currentUser?.uid,
      timestamp: DateTime.now(),
    );

    _service.collectionAdd(path: 'logs', data: systemLog.toMap());
  }

  Future<void> logEditItem(Item item, Place place) async {
    final username = await _currentUser();
    final itemName = item.name;
    final placeName = place.name;
    final systemLog = SystemLog(
      text: '$_formattedDate $username ALTEROU $itemName em $placeName',
      itemId: item.id,
      placeId: place.id,
      userId: _auth.currentUser?.uid,
      timestamp: DateTime.now(),
    );
    _service.collectionAdd(path: 'logs', data: systemLog.toMap());
  }

  Future<void> logEditPlace(Place placeOrigin, Place placeDestination) async {
    final username = await _currentUser();
    final placeOriginName = placeOrigin.name;
    final placeDestinationName = placeDestination.name;
    final systemLog = SystemLog(
      text: '$_formattedDate $username ALTEROU $placeOriginName para $placeDestinationName',
      placeId: placeOrigin.id,
      userId: _auth.currentUser?.uid,
      timestamp: DateTime.now(),
    );
    _service.collectionAdd(path: 'logs', data: systemLog.toMap());
  }

  Future<void> logMovedItem(Item item, Place placeOrigin, Place placeDestination) async {
    final username = await _currentUser();
    final itemName = item.name;
    final placeOriginName = placeOrigin.name;
    final placeDestinationName = placeDestination.name;
    final systemLog = SystemLog(
      text: '$_formattedDate $username MOVEU $itemName de $placeOriginName para $placeDestinationName',
      itemId: item.id,
      placeId: placeDestination.id,
      userId: _auth.currentUser?.uid,
      timestamp: DateTime.now(),
    );
    _service.collectionAdd(path: 'logs', data: systemLog.toMap());
  }

  Future<void> logRemoveItem(Item item, Place place) async {
    final username = await _currentUser();
    final itemName = item.name;
    final placeName = place.name;
    final systemLog = SystemLog(
      text: '$_formattedDate $username APAGOU $itemName de $placeName',
      itemId: item.id,
      placeId: place.id,
      userId: _auth.currentUser?.uid,
      timestamp: DateTime.now(),
    );
    _service.collectionAdd(path: 'logs', data: systemLog.toMap());
  }
}
