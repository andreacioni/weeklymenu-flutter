import 'package:flutter/material.dart';
import 'package:weekly_menu_app/globals/constants.dart' as consts;

import 'base_login_form.dart';

class RegisterForm extends StatefulWidget {
  final void Function() onBackToSignInPressed;

  RegisterForm({this.onBackToSignInPressed});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  String _name, _email, _password, _passwordVerification;

  @override
  Widget build(BuildContext context) {
    return BaseLoginForm(
      "Sign Up",
      "Register",
      [
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Name"),
          onSaved: (name) => _name = name,
        ),
        buildEmailFormField(onSaved: (email) => _email = email),
        buildPasswordFormField(
          onSaved: (password) => _password = password,
        ),
        buildPasswordFormField(
            hintText: "Confirm password",
            onSaved: (passwordVerification) =>
                _passwordVerification = passwordVerification),
      ],
      secondaryActionWidget:
          buildCancelButton(context, onCancel: widget.onBackToSignInPressed),
      formKey: _formKey,
      onSaved: _doRegistration,
    );
  }

  void _doRegistration() {}
}
