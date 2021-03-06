import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weekly_menu_app/globals/errors_handlers.dart';
import 'package:weekly_menu_app/providers/providers.dart';
import 'package:weekly_menu_app/services/auth_service.dart';

import '../screen.dart';
import 'base_login_form.dart';

class RegisterForm extends StatefulWidget {
  final void Function() onBackToSignInPressed;

  RegisterForm({this.onBackToSignInPressed});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  BaseLoginForm _form;

  String _name, _email, _password, _passwordVerification;

  @override
  Widget build(BuildContext context) {
    _form = BaseLoginForm(
      "Sign Up",
      "Register",
      [
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Name"),
          onSaved: (name) => _name = name,
          onChanged: (name) => _name = name,
        ),
        buildEmailFormField(
          onSaved: (email) => _email = email,
        ),
        buildPasswordFormField(
          onSaved: (password) => _password = password,
        ),
        buildPasswordFormField(
          hintText: "Confirm password",
          onSaved: (passwordVerification) =>
              _passwordVerification = passwordVerification,
          additionalValidator: (_) => _passwordVerification == _password
              ? null
              : "Passwords don't match",
          onFieldSubmitted: _doRegistration,
          textInputAction: TextInputAction.done,
        ),
      ],
      secondaryActionWidget:
          buildCancelButton(context, onCancel: widget.onBackToSignInPressed),
      formKey: _formKey,
      onSubmit: _doRegistration,
    );

    return _form;
  }

  void _doRegistration() {
    _form.validateAndSave(() async {
      final authService = context.read(authServiceProvider);

      showProgressDialog(context, dismissible: false);
      try {
        await authService.register(_name, _email, _password);

        hideProgressDialog(context);

        await showDialog(
            context: context,
            child: AlertDialog(
              content: Text(
                  "You were successfully registered to Weekly Menu! Please login"),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));

        goToLogin();
      } catch (e) {
        hideProgressDialog(context);
        showAlertErrorMessage(context,
            errorMessage: "New user registration failed. Try again later");
      }
    });
  }

  void goToLogin() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
