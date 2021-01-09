import 'package:flutter/material.dart';

class SaveIndicatorButton extends StatelessWidget {
  const SaveIndicatorButton({@required this.isLoading, @required this.onPressed, Key key}) : super(key: key);
  final void Function() onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).primaryColor,
      disabledColor: Theme.of(context).primaryColor.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SizedBox(
              height: 24,
              child: Text(
                'SALVAR',
                style: Theme.of(context).textTheme.button.merge(
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ),
    );
  }
}
