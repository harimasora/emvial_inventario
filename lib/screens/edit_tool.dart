import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/services/notification_service.dart';
import 'package:emival_inventario/widgets/save_indicator_button.dart';
import 'package:emival_inventario/widgets/tool_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/logger_service.dart';

class EditToolScreen extends ConsumerWidget {
  final Item item;
  final Place place;
  final List<Place> places;
  const EditToolScreen({Key? key, required this.item, required this.place, required this.places}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ferramenta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final isDelete = await NotificationService.confirm(
                  context, 'Apagar', 'Tem certeza que deseja apagar esta ferramenta?');
              if (isDelete == true) {
                final db = ref.read(databaseProvider);
                final Place origin = place;
                final originToSave = Place(id: origin.id, name: origin.name, items: origin.items)..items.remove(item);
                await db.savePlace(originToSave);
                await LoggerService().logRemoveItem(item, origin);
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

class EditToolForm extends ConsumerStatefulWidget {
  final Item item;
  final Place place;
  final List<Place> places;
  const EditToolForm({Key? key, required this.item, required this.place, required this.places}) : super(key: key);

  @override
  _EditToolFormState createState() => _EditToolFormState();
}

class _EditToolFormState extends ConsumerState<EditToolForm> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late Place place;
  late PlaceItem placeItem;

  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void startLoading() => setState(() => _isLoading = true);
  void finishLoading() => setState(() => _isLoading = false);

  @override
  void initState() {
    super.initState();
    name = widget.item.name;
    place = widget.place;
    placeItem = PlaceItem(place: widget.place, item: widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final overtextStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).primaryColor);
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
              onSaved: (String? value) {
                if (value != null) name = value;
              },
              initialValue: name,
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Place>(
              iconSize: 23,
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
              onChanged: (Place? value) {
                if (value != null) {
                  setState(() {
                    place = value;
                  });
                }
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

  String? _validateName(String? value) {
    if (value?.isEmpty == true) {
      return 'Insira um nome';
    }

    return null;
  }

  String? _validatePlace(Place? value) {
    if (value == null) {
      return 'Insira um local';
    }

    return null;
  }

  Future<void> _validateInputs() async {
    final form = _formKey.currentState;
    FocusScope.of(context).requestFocus(FocusNode());
    if (form?.validate() == true) {
      form?.save();
      try {
        startLoading();
        final db = ref.read(databaseProvider);

        final Place origin = widget.place;
        final Place destination = place;
        if (origin.id == destination.id) {
          final destinationToSave = Place(id: destination.id, name: destination.name, items: destination.items)
            ..items.removeWhere((item) => item.id == placeItem.item.id)
            ..items.add(placeItem.item.copyWith(name: name));
          await db.savePlace(destinationToSave);
          await LoggerService().logEditItem(placeItem.item.copyWith(name: name), origin);
        } else {
          final originToSave = Place(id: origin.id, name: origin.name, items: origin.items)
              .copyWith(items: [...origin.items]..remove(widget.item));
          final destinationToSave = Place(id: destination.id, name: destination.name, items: destination.items)
              .copyWith(items: [...destination.items, placeItem.item.copyWith(name: name)]);
          await Future.wait([
            db.savePlace(originToSave),
            db.savePlace(destinationToSave),
            LoggerService().logMovedItem(placeItem.item.copyWith(name: name), originToSave, destinationToSave),
          ]);
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

  Future<void> _deleteImage() async {
    final isDelete = await NotificationService.confirm(context, 'Apagar', 'Tem certeza que deseja apagar esta imagem?');
    if (isDelete == true) {
      final db = ref.read(databaseProvider);
      db.deleteImage(PlaceItem(place: widget.place, item: widget.item));
      setState(() {
        placeItem = PlaceItem(place: placeItem.place, item: placeItem.item.copyWith(imageUrl: ''));
      });
    }
  }
}
