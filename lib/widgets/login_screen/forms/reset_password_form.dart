import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_menu_app/providers/providers.dart';

import '../../../services/auth_service.dart';
import '../../../globals/errors_handlers.dart';

import '../screen.dart';
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
      final authService = context.read(authServiceProvider);

      showProgressDialog(context, dismissible: false);
      try {
        await authService.resetPassword(_email);

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

        goToLogin();
      } catch (e) {
        hideProgressDialog(context);
        showAlertErrorMessage(context,
            errorMessage: "Password reset failed. Try again later");
      }
    });
  }

  void goToLogin() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
