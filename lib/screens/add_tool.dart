import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class AddToolScreen extends StatelessWidget {
  final List<Place> places;
  const AddToolScreen({@required this.places, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ferramenta'),
      ),
      body: AddToolForm(places: places),
    );
  }
}

class AddToolForm extends StatefulWidget {
  final List<Place> places;
  const AddToolForm({@required this.places, Key key}) : super(key: key);

  @override
  _AddToolFormState createState() => _AddToolFormState();
}

class _AddToolFormState extends State<AddToolForm> {
  final _formKey = GlobalKey<FormState>();

  String name;
  Place place;

  @override
  Widget build(BuildContext context) {
    final List<Place> places = widget.places;
    places.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nome da ferramenta',
            ),
            onSaved: (String value) {
              name = value;
            },
            textCapitalization: TextCapitalization.words,
            validator: _validateName,
          ),
          DropdownButtonFormField<Place>(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _validateInputs,
              child: const Text('Criar'),
            ),
          ),
        ],
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
        final db = context.read(databaseProvider);
        final placeToSave = Place(id: place.id, name: place.name, items: place.items)..items.add(Item(name: name));
        await db.savePlace(placeToSave);
        Navigator.of(context).pop();
      } on Exception catch (e) {
        debugPrint(e.toString());
      } finally {}
    }
  }
}
