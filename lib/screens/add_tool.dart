import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/services/notification_service.dart';
import 'package:emival_inventario/widgets/save_indicator_button.dart';
import 'package:emival_inventario/widgets/tool_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToolScreen extends StatelessWidget {
  final Place place;
  const AddToolScreen({@required this.place, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ferramenta'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: AddToolForm(place: place),
          ),
        ),
      ),
    );
  }
}

class AddToolForm extends ConsumerStatefulWidget {
  final Place place;
  const AddToolForm({@required this.place, Key key}) : super(key: key);

  @override
  _AddToolFormState createState() => _AddToolFormState();
}

class _AddToolFormState extends ConsumerState<AddToolForm> {
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
    final db = ref.read(databaseProvider);
    place = widget.place;
    placeItem = PlaceItem(place: widget.place, item: Item(id: db.randomDocumentId, imageUrl: ''));
  }

  @override
  Widget build(BuildContext context) {
    final overtextStyle = Theme.of(context).textTheme.overline.copyWith(color: Theme.of(context).primaryColor);
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
              textCapitalization: TextCapitalization.words,
              validator: _validateName,
            ),
            const SizedBox(height: 16),
            Text('LOCAL:', style: overtextStyle),
            const SizedBox(height: 8),
            Text(place.name),
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

  Future<void> _validateInputs() async {
    final form = _formKey.currentState;
    FocusScope.of(context).requestFocus(FocusNode());
    if (form.validate()) {
      form.save();
      try {
        startLoading();
        final db = ref.read(databaseProvider);
        final placeToSave = Place(id: place.id, name: place.name, items: place.items);
        placeToSave.items.removeWhere((item) => item.id == placeItem.item.id);
        placeToSave.items.add(placeItem.item.copyWith(name: name));
        await db.savePlace(placeToSave);
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
    if (isDelete) {
      final db = ref.read(databaseProvider);
      db.deleteImage(PlaceItem(place: widget.place, item: placeItem.item));
      setState(() {
        placeItem = PlaceItem(place: placeItem.place, item: placeItem.item.copyWith(imageUrl: ''));
      });
    }
  }
}
