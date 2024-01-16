import 'package:common/errors_handlers.dart';
import 'package:data/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screen.dart';
import 'base_login_form.dart';

class RegisterForm extends StatefulWidget {
  final void Function()? onBackToSignInPressed;

  RegisterForm({this.onBackToSignInPressed});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  late BaseLoginForm _form;

  String? _name, _email, _password, _passwordVerification, _language;

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, _) {
        final authService = ref.read((authServiceProvider));
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
            buildLanguageFormField(
              hintText: "Language",
              onSaved: (language) => _language = language,
              textInputAction: TextInputAction.done,
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
              onFieldSubmitted: () => _doRegistration(authService),
              textInputAction: TextInputAction.done,
            ),
          ],
          secondaryActionWidget: buildCancelButton(context,
              onCancel: widget.onBackToSignInPressed),
          formKey: _formKey,
          onSubmit: () => _doRegistration(authService),
        );

        return _form;
      },
    );
  }

  void _doRegistration(AuthService authService) {
    _form.validateAndSave(() async {
      showProgressDialog(context, dismissible: false);
      try {
        await authService.register(_name!, _email!, _password!, _language!);

        hideProgressDialog(context);

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(
                      "You were successfully registered to Weekly Menu! Please login"),
                  actions: <Widget>[
                    TextButton(
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
