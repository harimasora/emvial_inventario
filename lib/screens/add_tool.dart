import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class AddToolScreen extends ConsumerWidget {
  const AddToolScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ferramenta'),
      ),
      body: const AddToolForm(),
    );
  }
}

class AddToolForm extends StatefulWidget {
  const AddToolForm({Key key}) : super(key: key);

  @override
  _AddToolFormState createState() => _AddToolFormState();
}

class _AddToolFormState extends State<AddToolForm> {
  final _formKey = GlobalKey<FormState>();

  String name;
  Place place;

  @override
  Widget build(BuildContext context) {
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
          Consumer(
            builder: (context, watch, child) {
              final inventory = watch(inventoryProvider);
              return DropdownButtonFormField<Place>(
                value: place,
                items: inventory.when(
                    data: (data) => data
                        .map((e) => DropdownMenuItem<Place>(
                              value: e,
                              child: Text(e.name),
                            ))
                        .toList(),
                    loading: () => [],
                    error: (e, s) => []),
                onChanged: (Place value) {
                  setState(() {
                    place = value;
                  });
                },
                validator: _validatePlace,
              );
            },
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
