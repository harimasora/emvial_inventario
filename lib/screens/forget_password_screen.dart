import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/login_state.dart';
import '../services/auth_service.dart';

class ForgetPasswordScreen extends StatefulHookConsumerWidget {
  const ForgetPasswordScreen({Key key}) : super(key: key);

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, (previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
      if (state is LoginStateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email enviado com sucesso'),
        ));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Esqueceu sua senha?')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: <Widget>[
            Hero(
              tag: 'logo-text',
              child: Image.asset(
                'assets/logo.png',
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('RECUPERAR SENHA'),
                onPressed: () {
                  ref.read(loginControllerProvider.notifier).sendPasswordResetEmail(emailController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
