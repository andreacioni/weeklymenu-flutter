import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import 'login_screen/screen.dart';

class FlutterDataStateBuilder<T extends Object> extends HookConsumerWidget {
  final DataState<T?> state;
  final Future<void> Function()? onRefresh;
  final Widget notFound;
  final Widget loading;
  final Widget error;
  final Widget Function(BuildContext context, T model) builder;

  FlutterDataStateBuilder(
      {required this.state,
      required this.builder,
      Widget? notFound,
      this.onRefresh,
      Widget? error,
      this.loading = const Center(child: CircularProgressIndicator())})
      : this.error = error ?? Text('error'),
        this.notFound = Container(height: 10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.hasException) {
      final ex = state.exception;
      if ((ex is DataException && ex.statusCode == 403) ||
          (ex is DataException && ex.statusCode == 401)) {
        Future.delayed(Duration.zero, () => goToLoginPage(context));
        return loading;
      }

      return error;
    }

    if (state.isLoading && !state.hasModel) {
      return loading;
    }

    final emptyModel = state.model == null ||
        ((state.model is List) && (state.model as List).isEmpty);

    final baseWidget = emptyModel ? notFound : builder(context, state.model!);

    var id;
    if (!(state.model is List)) {
      id = (state.model as BaseModel).id;
    }

    return onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: baseWidget,
          )
        : baseWidget;
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
