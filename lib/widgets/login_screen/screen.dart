import 'dart:ui';

import 'package:flutter/material.dart';

class LogingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flatButtonBorderRadius = BorderRadius.circular(30);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.amber, Colors.amberAccent[200]]),
            ),
          ),
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
                      "- AI powered daily menu organizer -",
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
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            child: Column(
                              children: [
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextField(
                                  autofocus: true,
                                  decoration:
                                      InputDecoration(hintText: "Email"),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                TextField(
                                  autofocus: true,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: "Password"),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                RaisedButton(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.amber[50],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: flatButtonBorderRadius,
                                  ),
                                  color: Colors.amber,
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "I've lost the password",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontFeatures: []),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      textColor: Colors.amber,
                      color: Colors.white,
                      minWidth: 350,
                      shape: RoundedRectangleBorder(
                        borderRadius: flatButtonBorderRadius,
                        side: BorderSide(color: Colors.amber[100], width: 3),
                      ),
                      splashColor: Colors.amber[100],
                      highlightColor: Colors.amber[100],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
