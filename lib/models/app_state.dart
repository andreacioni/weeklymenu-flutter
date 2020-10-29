import 'package:meta/meta.dart';

@immutable
class AppState {
  AppState();

  factory AppState.loading() => AppState();

  static AppState fromJson(dynamic json) => AppState();

  AppState copyWith() {
    return AppState();
  }
}
