import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/widgets/save_indicator_button.dart';
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: AddToolForm(places: places),
          ),
        ),
      ),
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

  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void startLoading() => setState(() => _isLoading = true);
  void finishLoading() => setState(() => _isLoading = false);

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
        final placeToSave = Place(id: place.id, name: place.name, items: place.items)..items.add(Item(name: name));
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
