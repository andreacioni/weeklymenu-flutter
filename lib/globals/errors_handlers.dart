import 'package:flutter/material.dart';

void showAlertErrorMessage(BuildContext context,
    {String errorMessage =
        'There was an error trying to reach remote server.'}) {
  showDialog(
      context: context,
      child: AlertDialog(
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ));
}

void showProgressDialog(BuildContext context, {String message = 'Loading...', bool dismissible = true}) {
  showDialog(
      context: context,
      barrierDismissible: dismissible,
      child: AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ));
}

void hideProgressDialog(BuildContext context, {String message = 'Loading...'}) {
  Navigator.of(context).pop();
}
