import 'package:flutter/material.dart';
import 'package:weekly_menu_app/globals/constants.dart' as consts;

import 'base_login_form.dart';

class ResetPasswordForm extends StatefulWidget {
  final void Function() onBackToSignInPressed;

  ResetPasswordForm({this.onBackToSignInPressed});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  String _email;

  @override
  Widget build(BuildContext context) {
    return BaseLoginForm(
      "Password Recovery",
      "Send email",
      [
        buildEmailFormField(onSaved: (email) => _email),
      ],
      secondaryActionWidget:
          buildCancelButton(context, onCancel: widget.onBackToSignInPressed),
      formKey: _formKey,
      onSaved: _doResetPassword,
    );
  }

  void _doResetPassword() {}
}
