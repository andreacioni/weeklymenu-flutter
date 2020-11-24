import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/globals/constants.dart';
import 'package:weekly_menu_app/globals/errors_handlers.dart';
import 'package:weekly_menu_app/homepage.dart';
import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/services/auth_service.dart';

import 'base_login_form.dart';

class SignInForm extends StatefulWidget {
  final void Function() onLostPasswordPressed;

  SignInForm({this.onLostPasswordPressed});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BaseLoginForm _form;

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    _form = BaseLoginForm(
      "Sign In",
      "Login",
      [
        buildEmailFormField(
          onSaved: (email) => _email = email,
        ),
        buildPasswordFormField(
          onSaved: (password) => _password = password,
          onFieldSubmitted: _doSignIn,
        )
      ],
      secondaryActionWidget: FlatButton(
        child: Text(
          "I've lost the password",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFeatures: [],
          ),
        ),
        onPressed: widget.onLostPasswordPressed,
        splashColor: Theme.of(context).accentColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
            borderRadius: BaseLoginForm.flatButtonBorderRadius),
      ),
      formKey: _formKey,
      onSubmit: _doSignIn,
    );

    return _form;
  }

  void _doSignIn() {
    _form.validateAndSave(() async {
      var authService = AuthService.getInstance();

      showProgressDialog(context, dismissible: false);
      try {
        await authService.login(_email, _password);

        hideProgressDialog(context);
        goToHomepage();
      } catch (e) {
        hideProgressDialog(context);
        showAlertErrorMessage(context, errorMessage: "Check your credentials");
      }
    });
  }

  void goToHomepage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
  }
}
