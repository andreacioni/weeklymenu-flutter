import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String BASE_URL = 'https://heroku-weeklymenu.herokuapp.com/api/v1';

final dioProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      connectTimeout: 2000,
      receiveTimeout: 2000,
      sendTimeout: 2000,
    ),
  ),
);
