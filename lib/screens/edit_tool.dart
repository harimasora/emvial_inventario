import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/services/notification_service.dart';
import 'package:emival_inventario/widgets/image_capture.dart';
import 'package:emival_inventario/widgets/save_indicator_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class EditToolScreen extends StatelessWidget {
  final Item item;
  final Place place;
  final List<Place> places;
  const EditToolScreen({@required this.item, @required this.place, @required this.places, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ferramenta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final isDelete = await NotificationService.confirm(
                  context, 'Apagar', 'Tem certeza que deseja apagar esta ferramenta?');
              if (isDelete) {
                final db = context.read(databaseProvider);
                final Place origin = place;
                final originToSave = Place(id: origin.id, name: origin.name, items: origin.items)..items.remove(item);
                await db.savePlace(originToSave);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: EditToolForm(item: item, place: place, places: places),
          ),
        ),
      ),
    );
  }
}

class EditToolForm extends StatefulWidget {
  final Item item;
  final Place place;
  final List<Place> places;
  const EditToolForm({@required this.item, @required this.place, @required this.places, Key key}) : super(key: key);

  @override
  _EditToolFormState createState() => _EditToolFormState();
}

class _EditToolFormState extends State<EditToolForm> {
  final _formKey = GlobalKey<FormState>();

  String name;
  Place place;
  PlaceItem placeItem;

  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void startLoading() => setState(() => _isLoading = true);
  void finishLoading() => setState(() => _isLoading = false);

  @override
  void initState() {
    super.initState();
    name = widget.item?.name;
    place = widget.place;
    placeItem = PlaceItem(place: widget.place, item: widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final overtextStyle = Theme.of(context).textTheme.overline.copyWith(color: Theme.of(context).primaryColor);
    final List<Place> places = widget.places;
    places.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidate,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('DADOS DA FERRAMENTA', style: overtextStyle),
            const SizedBox(height: 16),
            Center(
              child: ToolImage(
                placeItem: placeItem,
                onDelete: _deleteImage,
                onUploadComplete: (downloadUrl) {
                  setState(() {
                    placeItem = PlaceItem(place: placeItem.place, item: placeItem.item.copyWith(imageUrl: downloadUrl));
                  });
                },
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              onSaved: (String value) {
                name = value;
              },
              initialValue: name ?? '',
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Place>(
              decoration: const InputDecoration(
                labelText: 'Local',
              ),
              value: place,
              items: places
                  .map((e) => DropdownMenuItem<Place>(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (Place value) {
                setState(() {
                  place = value;
                });
              },
              validator: _validatePlace,
            ),
            const SizedBox(height: 16),
            SaveIndicatorButton(
              isLoading: _isLoading,
              onPressed: _validateInputs,
            ),
          ],
        ),
      ),
    );
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return 'Insira um nome';
    }

    return null;
  }

  String _validatePlace(Place value) {
    if (value == null) {
      return 'Insira um local';
    }

    return null;
  }

  Future<void> _validateInputs() async {
    final form = _formKey.currentState;
    FocusScope.of(context).requestFocus(FocusNode());
    if (form.validate()) {
      form.save();
      try {
        startLoading();
        final db = context.read(databaseProvider);

        final Place origin = widget.place;
        final Place destination = place;
        if (origin.id == destination.id) {
          final destinationToSave = Place(id: destination.id, name: destination.name, items: destination.items)
            ..items.remove(widget.item)
            ..items.add((Item(name: name)));
          await db.savePlace(destinationToSave);
        } else {
          final originToSave = Place(id: origin.id, name: origin.name, items: origin.items)..items.remove(widget.item);
          final destinationToSave = Place(id: destination.id, name: destination.name, items: destination.items)
            ..items.add((Item(name: name)));
          await Future.wait([db.savePlace(originToSave), db.savePlace(destinationToSave)]);
        }
        Navigator.of(context).pop();
      } on Exception catch (e) {
        debugPrint(e.toString());
      } finally {
        finishLoading();
      }
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }

  void _deleteImage() {
    final db = context.read(databaseProvider);
    db.deleteImage(PlaceItem(place: widget.place, item: widget.item));
    setState(() {
      placeItem = PlaceItem(place: placeItem.place, item: placeItem.item.copyWith(imageUrl: ''));
    });
  }
}

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
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
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
