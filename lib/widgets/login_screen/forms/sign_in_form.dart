import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_menu_app/homepage.dart';
import 'package:weekly_menu_app/providers/rest_provider.dart';

import 'base_login_form.dart';

class SignInForm extends StatefulWidget {
  final void Function() onLostPasswordPressed;

  SignInForm({this.onLostPasswordPressed});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return BaseLoginForm(
      "Sign In",
      "Login",
      [
        buildEmailFormField(onSaved: (email) => _email = email),
        buildPasswordFormField(onSaved: (password) => _password = password)
      ],
      secondaryActionWidget: FlatButton(
        child: Text(
          "I've lost the password",
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontFeatures: []),
        ),
        onPressed: widget.onLostPasswordPressed,
        splashColor: Theme.of(context).accentColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
            borderRadius: BaseLoginForm.flatButtonBorderRadius),
      ),
      formKey: _formKey,
      onSaved: _doSignIn,
    );
  }

  void _doSignIn() {}
}
