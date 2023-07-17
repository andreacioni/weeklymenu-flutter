import 'package:flutter/foundation.dart';

class Data<T> {
  final T? content;
  final bool loading;

  Data({this.content, required this.loading});

  factory Data.loading() => Data(loading: true);
  factory Data.data(T content) => Data(content: content, loading: false);
}
