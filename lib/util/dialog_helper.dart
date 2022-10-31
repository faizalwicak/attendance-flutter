import 'package:flutter/material.dart';

void displayDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(content: Text(text));
    },
  );
}

void displayMessageDialog(BuildContext context, String text,
    [Function? okCallback]) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              if (okCallback != null) {
                okCallback.call();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void displayConfirmDialog({
  required BuildContext context,
  required String text,
  required Function callback,
  String okTitle = 'OK',
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () {
              callback.call();
              Navigator.of(context).pop();
            },
            child: Text(okTitle),
          ),
        ],
      );
    },
  );
}
