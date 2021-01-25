import 'package:emival_inventario/models/item.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/widgets/save_indicator_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

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

class AddToolForm extends StatefulWidget {
  final Place place;
  const AddToolForm({@required this.place, Key key}) : super(key: key);

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
  void initState() {
    super.initState();
    place = widget.place;
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
        final db = context.read(databaseProvider);
        final placeToSave = Place(id: place.id, name: place.name, items: place.items)
          ..items.add(Item(id: db.randomDocumentId, name: name));
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
