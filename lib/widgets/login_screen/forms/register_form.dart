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
  @override
  Widget build(BuildContext context) {
    return BaseLoginForm(
      "Sign Up",
      "Register",
      [
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Name"),
          keyboardType: TextInputType.emailAddress,
        ),
        buildEmailFormField(),
        buildPasswordFormField(),
        buildPasswordFormField(hintText: "Confirm password"),
      ],
      secondaryActionWidget:
          buildCancelButton(context, widget.onBackToSignInPressed),
      formKey: _formKey,
    );
  }
}
