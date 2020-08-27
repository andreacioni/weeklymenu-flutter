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
  @override
  Widget build(BuildContext context) {
    return BaseLoginForm(
      "Password Recovery",
      "Send email",
      [
        buildEmailFormField(),
      ],
      secondaryActionWidget:
          buildCancelButton(context, widget.onBackToSignInPressed),
      formKey: _formKey,
    );
  }
}
