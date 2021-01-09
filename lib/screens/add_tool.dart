import 'package:flutter/material.dart';

class AddToolScreen extends StatelessWidget {
  const AddToolScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ferramenta'),
      ),
      body: const Center(
        child: Text('Adicionar Ferramenta'),
      ),
    );
  }
}
