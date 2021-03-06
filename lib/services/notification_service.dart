import 'package:flutter/material.dart';

class NotificationService {
  static Future<bool> confirm(BuildContext context, String title, String body, [String deleteLabel]) async {
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
            FlatButton(
              onPressed: () => Navigator.of(innerContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FlatButton(
              color: Theme.of(innerContext).errorColor,
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
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
