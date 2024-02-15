import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/db_service.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsStream = ref.watch(logsStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Registros')),
      body: logsStream.when(
        data: (logs) {
          logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return ListView.separated(
            itemCount: logs.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(logs[index].text),
            ),
            separatorBuilder: (context, index) => const Divider(),
          );
        },
        error: (err, _) {
          return Column(
            children: [
              const Text('Ocorreu um erro ao carregar os registros.'),
              Text(err.toString()),
            ],
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
