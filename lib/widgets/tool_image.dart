import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/widgets/image_capture.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ToolImage extends StatelessWidget {
  const ToolImage({
    Key key,
    @required this.placeItem,
    this.onDelete,
    this.onUploadComplete,
  }) : super(key: key);
  final PlaceItem placeItem;
  final void Function() onDelete;
  final void Function(String downloadUrl) onUploadComplete;

  @override
  Widget build(BuildContext context) {
    final item = placeItem.item;
    final imageSideSize = MediaQuery.of(context).size.width / 3;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[400],
          ),
          width: imageSideSize,
          height: imageSideSize,
          child: item.imageUrl.isEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.photo,
                    size: 32,
                  ),
                  onPressed: () async {
                    final String downloadUrl = await Navigator.of(context).push<String>(
                          MaterialPageRoute<String>(
                            builder: (_) => ImageCapture(
                              placeItem: placeItem,
                            ),
                          ),
                        ) ??
                        '';
                    if (downloadUrl.isNotEmpty) {
                      onUploadComplete(downloadUrl);
                    }
                  },
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder: (context) => Scaffold(
                        appBar: AppBar(),
                        body: PinchZoom(
                          image: Image.network(item.imageUrl),
                          zoomedBackgroundColor: Colors.black.withOpacity(0.5),
                          maxScale: 2.5,
                        ),
                      ),
                    ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
        if (item.imageUrl.isNotEmpty)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.redAccent,
              ),
              child: GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}
