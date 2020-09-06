import 'package:flutter/material.dart';

import 'package:weekly_menu_app/globals/constants.dart' as consts;

class BaseLoginForm extends StatelessWidget {
  static final BorderRadius flatButtonBorderRadius = BorderRadius.circular(30);

  final String title;
  final String action;
  final void Function() onSaved;
  final List<TextFormField> textFields;
  final Widget secondaryActionWidget;
  final GlobalKey<FormState> formKey;

  BaseLoginForm(this.title, this.action, this.textFields,
      {this.secondaryActionWidget,
      @required this.onSaved,
      @required this.formKey});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ...textFields,
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  child: Text(
                    action,
                    style: TextStyle(
                        color: Colors.amber[50], fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: flatButtonBorderRadius,
                  ),
                  color: Colors.amber,
                  onPressed: onSubmit,
                ),
                SizedBox(
                  height: 10,
                ),
                if (secondaryActionWidget != null) secondaryActionWidget
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    onSaved();
  }
}

TextFormField buildEmailFormField(
    {@required void Function(String value) onSaved}) {
  return TextFormField(
    autofocus: true,
    decoration: InputDecoration(hintText: "Email"),
    keyboardType: TextInputType.emailAddress,
    validator: _validateEmail,
    onSaved: onSaved,
  );
}

TextFormField buildPasswordFormField(
    {@required void Function(String value) onSaved,
    String hintText = "Password"}) {
  return TextFormField(
    autofocus: true,
    obscureText: true,
    decoration: InputDecoration(hintText: hintText),
    validator: _validatePassword,
    onSaved: onSaved,
  );
}

FlatButton buildCancelButton(BuildContext context, {void Function() onCancel}) {
  return FlatButton(
    child: Text(
      "Cancel",
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.bold, fontFeatures: []),
    ),
    onPressed: onCancel,
    splashColor: Theme.of(context).accentColor.withOpacity(0.1),
    shape: RoundedRectangleBorder(
        borderRadius: BaseLoginForm.flatButtonBorderRadius),
  );
}

String _validateEmail(String value,
    {@required void Function(String value) onSaved}) {
  if (!RegExp(consts.emailValidationRegex).hasMatch(value)) {
    return "Enter a valid email address";
  }

  return null;
}

String _validatePassword(String value,
    {@required void Function(String value) onSaved}) {
  if (!RegExp(consts.passwordValidationRegex).hasMatch(value)) {
    return "Password must be at least 8 characters long";
  }

  return null;
}
