import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/widgets/save_indicator_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPlaceScreen extends StatelessWidget {
  final Place place;
  const EditPlaceScreen({@required this.place, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Local'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: EditPlaceForm(place: place),
          ),
        ),
      ),
    );
  }
}

class EditPlaceForm extends ConsumerStatefulWidget {
  final Place place;
  const EditPlaceForm({@required this.place, Key key}) : super(key: key);

  @override
  _EditPlaceFormState createState() => _EditPlaceFormState();
}

class _EditPlaceFormState extends ConsumerState<EditPlaceForm> {
  final _formKey = GlobalKey<FormState>();

  String name;

  bool _isLoading = false;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void startLoading() => setState(() => _isLoading = true);
  void finishLoading() => setState(() => _isLoading = false);

  @override
  void initState() {
    super.initState();
    name = widget.place.name;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('DADOS DO LOCAL', style: overtextStyle),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              onSaved: (String value) {
                name = value;
              },
              initialValue: name ?? '',
              textCapitalization: TextCapitalization.words,
              validator: validateName,
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

  String validateName(String value) {
    if (value.isEmpty) {
      return 'Insira um nome';
    }

    return null;
  }

  Future<void> _validateInputs() async {
    final form = _formKey.currentState;
    FocusScope.of(context).requestFocus(FocusNode());
    if (form.validate()) {
      // Text forms was validated.
      form.save();
      try {
        startLoading();
        final db = ref.read(databaseProvider);
        final place = widget.place;
        final placeToSave = Place(id: place.id, name: name, items: place.items);
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
