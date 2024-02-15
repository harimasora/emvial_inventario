import 'dart:io';
import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Uploader extends ConsumerStatefulWidget {
  final File file;
  final PlaceItem placeItem;
  const Uploader({Key? key, required this.file, required this.placeItem}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends ConsumerState<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask? _task;

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    final String filePath = 'tools/${widget.placeItem.item.id}.png';

    setState(() {
      // TODO: Fix upload
      _task = _storage.ref().child(filePath).putFile(widget.file);
      _task?.whenComplete(() async {
        final downloadUrl = await _task?.snapshot.ref.getDownloadURL();
        final newItem = widget.placeItem.item.copyWith(imageUrl: downloadUrl!);
        final db = ref.read(databaseProvider);
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
          stream: _task!.snapshotEvents,
          builder: (_, asyncSnapshot) {
            final TaskSnapshot? snapshot = asyncSnapshot.data;
            final TaskState? state = snapshot?.state;

            final double progressPercent = snapshot != null ? snapshot.bytesTransferred / snapshot.totalBytes : 0;

            return Column(
              children: [
                if (state == TaskState.success) const Text('Upload concluído! 🎉🎉🎉'),

                if (state == TaskState.paused)
                  TextButton(
                    onPressed: _task!.resume,
                    child: const Icon(Icons.play_arrow),
                  ),

                if (state == TaskState.running)
                  TextButton(
                    onPressed: _task!.pause,
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
      return TextButton.icon(
        label: const Text('Fazer upload'),
        icon: const Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
