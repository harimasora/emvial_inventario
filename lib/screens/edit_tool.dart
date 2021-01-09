import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
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

  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void startLoading() => setState(() => _isLoading = true);
  void finishLoading() => setState(() => _isLoading = false);

  @override
  void initState() {
    super.initState();
    name = widget.item?.name;
    place = widget.place;
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
        final placeToSave = Place(id: place.id, name: place.name, items: place.items)
          ..items.remove(widget.item)
          ..items.add((Item(name: name)));
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
}
