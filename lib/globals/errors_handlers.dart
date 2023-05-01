import 'package:flutter/material.dart';

void showAlertErrorMessage(BuildContext context,
    {String errorMessage =
        'There was an error trying to reach remote server.'}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
}

void showProgressDialog(BuildContext context,
    {String message = 'Loading...', bool dismissible = true}) {
  showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog(
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Text(message),
              ],
            ),
          ));
}

void hideProgressDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Future<bool?> showWannaSaveDialog(BuildContext context) {
  return showDialog<bool>(
    builder: (context) => AlertDialog(
      title: Text("Are you sure?"),
      content: Text(
          "You are leaving this screen with unsaved changes. Would you like to save them?"),
      actions: [
        TextButton(
          child: Text("NO"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text("YES"),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    ),
    context: context,
  );
}
