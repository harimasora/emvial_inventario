import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class NotificationService {
  static Future<bool?> confirm(BuildContext context, String title, String body, [String? deleteLabel]) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext innerContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(innerContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(innerContext).colorScheme.error,
              ),
              onPressed: () => Navigator.of(innerContext).pop(true),
              child: Text(deleteLabel ?? 'Apagar', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  static Future<void> error(BuildContext context, String title, String body) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
