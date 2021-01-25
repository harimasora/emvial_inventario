import 'dart:io';
import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Uploader extends StatefulWidget {
  final File file;
  final PlaceItem placeItem;
  const Uploader({@required this.file, @required this.placeItem, Key key}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://emival-engenharia-inventario.appspot.com');

  UploadTask _task;

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    final String filePath = 'tools/${widget.placeItem.item.id}.png';

    setState(() {
      _task = _storage.ref().child(filePath).putFile(widget.file);
      _task.whenComplete(() async {
        final downloadUrl = await _task.snapshot.ref.getDownloadURL();
        final newItem = widget.placeItem.item.copyWith(imageUrl: downloadUrl);
        final db = context.read(databaseProvider);
        db.savePlaceItem(PlaceItem(place: widget.placeItem.place, item: newItem));
        Navigator.of(context).pop(downloadUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_task != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<TaskSnapshot>(
          stream: _task.snapshotEvents,
          builder: (_, asyncSnapshot) {
            final TaskSnapshot snapshot = asyncSnapshot.data;
            final TaskState state = snapshot?.state;

            final double progressPercent = snapshot != null ? snapshot.bytesTransferred / snapshot.totalBytes : 0;

            return Column(
              children: [
                if (state == TaskState.success) const Text('Upload concluído! 🎉🎉🎉'),

                if (state == TaskState.paused)
                  FlatButton(
                    onPressed: _task.resume,
                    child: const Icon(Icons.play_arrow),
                  ),

                if (state == TaskState.running)
                  FlatButton(
                    onPressed: _task.pause,
                    child: const Icon(Icons.pause),
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: const Text('Fazer upload'),
        icon: const Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
