import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/auth_service.dart';
import '../../../globals/errors_handlers.dart';
import '../screen.dart';
import 'base_login_form.dart';

class ResetPasswordForm extends StatefulWidget {
  final void Function()? onBackToSignInPressed;

  ResetPasswordForm({this.onBackToSignInPressed});

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  late BaseLoginForm _form;

  String? _email;

  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: ((context, ref, _) {
      final authService = ref.read(authServiceProvider);
      _form = BaseLoginForm(
        "Password Recovery",
        "Send email",
        [
          buildEmailFormField(
            onSaved: (email) => _email = email,
            onFieldSubmitted: () => _doResetPassword(authService),
          ),
        ],
        secondaryActionWidget:
            buildCancelButton(context, onCancel: widget.onBackToSignInPressed),
        formKey: _formKey,
        onSubmit: () => _doResetPassword(authService),
      );

      return _form;
    }));
  }

  void _doResetPassword(AuthService authService) {
    _form.validateAndSave(() async {
      showProgressDialog(context, dismissible: false);
      try {
        await authService.resetPassword(_email!);

        hideProgressDialog(context);

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
