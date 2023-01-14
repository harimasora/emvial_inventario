import 'package:emival_inventario/screens/logs_screen.dart';
import 'package:emival_inventario/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Registros'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder: (context) => const LogsScreen(),
              ));
            },
          ),
          const Divider(),
          const SizedBox(height: 24),
          const CurrentUser(),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(loginControllerProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

class CurrentUser extends ConsumerWidget {
  const CurrentUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);

    return user.when(
      data: (user) {
        if (user == null) {
          return const Text('Erro ao fazer login. Tente sair e fazer login novamente.');
        }
        return Text('Logado como ${user?.displayName ?? user?.email}');
      },
      error: (err, __) {
        return Column(
          children: [
            const Text('Erro ao identificar usuário'),
            Text(err.toString()),
          ],
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
