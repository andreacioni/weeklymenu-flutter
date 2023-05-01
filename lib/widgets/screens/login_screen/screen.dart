import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weekly_menu_app/widgets/screens/login_screen/forms/base_login_form.dart';
import 'package:weekly_menu_app/widgets/screens/login_screen/forms/register_form.dart';
import 'package:weekly_menu_app/widgets/screens/login_screen/forms/reset_password_form.dart';
import 'package:weekly_menu_app/widgets/screens/login_screen/forms/sign_in_form.dart';

enum LoginScreenMode {
  SignIn,
  Register,
  LostPassword,
}

class LoginScreen extends StatefulWidget {
  static final backgroudContainer = Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.amber, Colors.amberAccent[200]!]),
    ),
  );

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginScreenMode mode;

  @override
  void initState() {
    mode = LoginScreenMode.SignIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LoginScreen.backgroudContainer,
          ListView(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Weekly Menu",
                      style: TextStyle(
                        fontFamily: "Milkshake",
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "- AI-powered Daily Menu Organizer -",
                      style: TextStyle(
                        fontFamily: "Milkshake",
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: buildMainForm(),
                    ),
                    if (mode != LoginScreenMode.Register) ...[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () =>
                            setState(() => mode = LoginScreenMode.Register),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        style: ButtonStyle(
                          textStyle: MaterialStatePropertyAll(
                              TextStyle(color: Colors.amber)),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.amber[100];
                            if (states.contains(MaterialState.hovered))
                              return Colors
                                  .amber[100]; // Defer to the widget's default.
                          }),
                          minimumSize: MaterialStatePropertyAll(Size(250, 0)),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BaseLoginForm.TextButtonBorderRadius,
                              side: BorderSide(
                                  color: Colors.amber[100]!, width: 3),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget? buildMainForm() {
    switch (mode) {
      case LoginScreenMode.SignIn:
        return SignInForm(
          onLostPasswordPressed: toResetPasswordForm,
        );
      case LoginScreenMode.Register:
        return RegisterForm(
          onBackToSignInPressed: toSignInForm,
        );
      case LoginScreenMode.LostPassword:
        return ResetPasswordForm(
          onBackToSignInPressed: toSignInForm,
        );
    }
  }

  void toSignInForm() => setState(() => mode = LoginScreenMode.SignIn);

  void toResetPasswordForm() =>
      setState(() => mode = LoginScreenMode.LostPassword);
}
