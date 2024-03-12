import 'dart:io';

import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/widgets/uploader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  final PlaceItem placeItem;
  const ImageCapture({Key? key, required this.placeItem}) : super(key: key);

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File? _imageFile;
  final _picker = ImagePicker();

  /// Cropper plugin
  Future<void> _cropImage() async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: _imageFile?.path ?? '',
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxWidth: 1024,
      maxHeight: 1024,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.purple,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Recortar',
        ),
        WebUiSettings(
          context: context,
        )
      ],
    );

    setState(() {
      _imageFile = cropped?.path != null ? File(cropped!.path) : _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 100,
    );

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload de imagem'),
      ),
      body: Column(
        children: <Widget>[
          // Select an image from the camera or gallery
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
          // Preview the image and crop it
          if (_imageFile != null) ...[
            if (kIsWeb) Image.network(_imageFile!.path) else Image.file(_imageFile!),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: _cropImage,
                  child: const Icon(Icons.crop),
                ),
                TextButton(
                  onPressed: _clear,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
            Uploader(
              file: _imageFile!,
              placeItem: widget.placeItem,
            )
          ]
        ],
      ),
    );
  }
}
