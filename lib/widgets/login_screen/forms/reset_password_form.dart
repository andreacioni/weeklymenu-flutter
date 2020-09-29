import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_menu_app/globals/constants.dart';
import 'package:weekly_menu_app/globals/errors_handlers.dart';
import 'package:weekly_menu_app/homepage.dart';
import 'package:weekly_menu_app/models/auth_token.dart';
import 'package:weekly_menu_app/providers/auth_provider.dart';
import 'package:weekly_menu_app/widgets/splash_screen/screen.dart';

import 'base_login_form.dart';

class ResetPasswordForm extends StatefulWidget {
  final void Function() onBackToSignInPressed;

  ResetPasswordForm({this.onBackToSignInPressed});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  BaseLoginForm _form;

  String _email;

  @override
  Widget build(BuildContext context) {
    _form = BaseLoginForm(
      "Password Recovery",
      "Send email",
      [
        buildEmailFormField(
          onSaved: (email) => _email = email,
          onFieldSubmitted: _doResetPassword,
        ),
      ],
      secondaryActionWidget:
          buildCancelButton(context, onCancel: widget.onBackToSignInPressed),
      formKey: _formKey,
      onSubmit: _doResetPassword,
    );

    return _form;
  }

  void _doResetPassword() {
    _form.validateAndSave(() async {
      var restProvider = Provider.of<AuthProvider>(context, listen: false);

      showProgressDialog(context, dismissible: false);
      try {
        await restProvider.resetPassword(_email);

        hideProgressDialog(context);

        await showDialog(
            context: context,
            child: AlertDialog(
              content: Text(
                  "An e-mail was sent to you! Please follow the instructions provided in the message in order to reset your password"),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));

        SplashScreen.goToLogin(context);
      } catch (e) {
        hideProgressDialog(context);
        showAlertErrorMessage(context,
            errorMessage: "Password reset failed. Try again later");
      }
    });
  }
}
