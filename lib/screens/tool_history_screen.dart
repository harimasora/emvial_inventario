import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/db_service.dart';

class ToolHistoryScreen extends ConsumerWidget {
  const ToolHistoryScreen({Key? key, required this.itemId}) : super(key: key);

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemHistory = ref.watch(itemHistoryProvider(itemId));
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Ferramentas')),
      body: itemHistory.when(
        data: (data) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                        builder: (context) => Scaffold(
                          appBar: AppBar(),
                          body: ExtendedImage.network(
                            data.imageUrl,
                            fit: BoxFit.contain,
                            //enableLoadState: false,
                            mode: ExtendedImageMode.gesture,
                            initGestureConfigHandler: (state) {
                              return GestureConfig(
                                minScale: 0.9,
                                animationMinScale: 0.7,
                                maxScale: 3.0,
                                animationMaxScale: 3.5,
                              );
                            },
                          ),
                        ),
                      ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.separated(
                  itemCount: data.logs.length,
                  itemBuilder: (context, index) {
                    final log = data.logs[index];
                    return ListTile(
                      title: Text(log.text),
                      subtitle: Text(log.timestamp.toString()),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          debugPrint('Error: $error');
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ocorreu um erro ao carregar o histórico.'),
                Text(error.toString()),
              ],
            ),
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
