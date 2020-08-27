import 'package:flutter/material.dart';

import 'base_login_form.dart';

class SignInForm extends StatefulWidget {
  final void Function() onLostPasswordPressed;

  SignInForm({this.onLostPasswordPressed});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseLoginForm(
      "Sign In",
      "Login",
      [
        buildEmailFormField(),
        TextFormField(
          autofocus: true,
          obscureText: true,
          decoration: InputDecoration(hintText: "Password"),
        )
      ],
      onSubmit: _onLoginSubmit,
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
    );
  }

  void _onLoginSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
  }
}
