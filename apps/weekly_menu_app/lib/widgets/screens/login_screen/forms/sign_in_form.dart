import 'package:common/errors_handlers.dart';
import 'package:data/auth/auth_service.dart';
import 'package:data/configuration/local_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/auth_token.dart';

import '../../homepage/homepage.dart';
import 'base_login_form.dart';

class SignInForm extends StatefulHookConsumerWidget {
  final void Function()? onLostPasswordPressed;

  SignInForm({this.onLostPasswordPressed});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late BaseLoginForm _form;

  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    final authService = ref.read((authServiceProvider));
    final localPreferences = ref.read(localPreferencesProvider);

    void goToHomepage() {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    }

    Future<void> storeUserInformation(
        String email, String password, AuthToken token) async {
      await localPreferences.setString(LocalPreferenceKey.email, email);
      await localPreferences.setString(LocalPreferenceKey.password, password,
          secret: true);

      await localPreferences.setString(LocalPreferenceKey.token, token.jwt,
          secret: true);
    }

    void doSignIn(AuthService authService) {
      _form.validateAndSave(() async {
        showProgressDialog(context, dismissible: false);
        try {
          final authToken = await authService.login(_email!, _password!);

          storeUserInformation(_email!, _password!, authToken);

          hideProgressDialog(context);
          goToHomepage();
        } catch (e) {
          hideProgressDialog(context);
          showAlertErrorMessage(context,
              errorMessage: "Check your credentials");
        }
      });
    }

    _form = BaseLoginForm(
      "Sign In",
      "Login",
      [
        buildEmailFormField(
          onSaved: (email) => _email = email,
        ),
        buildPasswordFormField(
          onSaved: (password) => _password = password,
          onFieldSubmitted: () => doSignIn(authService),
        )
      ],
      secondaryActionWidget: TextButton(
        child: Text(
          "I've lost the password",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontFeatures: [],
          ),
        ),
        onPressed: widget.onLostPasswordPressed,
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BaseLoginForm.TextButtonBorderRadius),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).accentColor.withOpacity(0.1);
            return null; // Defer to the widget's default.
          }),
        ),
      ),
      formKey: _formKey,
      onSubmit: () => doSignIn(authService),
    );

    return _form;
  }
}
