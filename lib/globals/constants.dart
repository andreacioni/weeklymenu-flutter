import 'package:flutter/material.dart';

const String BASE_URL = 'https://heroku-weeklymenu.herokuapp.com/api/v1';

final pageViewLimitDays = 365 * 2;

const todayColor = Color.fromRGBO(183, 223, 189, 1);
const pastColor = Color.fromRGBO(178, 185, 222, 1);

const String emailValidationRegex =
    "(^[a-zA-Z0-9_.+-]{2,}@[a-zA-Z0-9-.]{2,}\.[a-zA-Z]{2,}\$)";

const String alloweSpecialCharacters = "?\$#!'\"=%&/\/\(\)\[\]\{\}";
const String passwordValidationRegex = "^[a-zA-Z0-9]{7,20}\$";

class SharedPreferencesKeys {
  static final String tokenSharedPreferencesKey = "token";
  static final String emailSharedPreferencesKey = "username";
  static final String passwordSharedPreferencesKey = "password";
}
