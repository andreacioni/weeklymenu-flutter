import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/models/base_model.dart';

import '../screens/login_screen/screen.dart';

class FlutterDataStateBuilder<T extends Object> extends HookConsumerWidget {
  final DataState<T?> state;
  final Future<void> Function()? onRefresh;
  final Widget? notFound;
  final Widget loading;
  final Widget error;
  final Widget Function(BuildContext context, T model) builder;

  FlutterDataStateBuilder(
      {required this.state,
      required this.builder,
      this.onRefresh,
      this.notFound = const Text('not found'),
      this.error = const Text('error'),
      this.loading = const Center(child: CircularProgressIndicator())});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.hasException) {
      //early catch the forbidden/unauthorized to redirect user to login page
      final ex = state.exception;
      if (ex?.statusCode == 403 || ex?.statusCode == 401) {
        Future.delayed(Duration.zero, () => goToLoginPage(context));
        return loading;
      }

      // for other errors shows popup ?
      log(
          "FlutterDataStateBuilder caught an error: " +
              (ex?.toString() ?? 'null'),
          level: Level.SEVERE.value,
          error: ex);
    }

    if (state.isLoading && !state.hasModel) {
      return loading;
    }

    final emptyModel = state.model == null ||
        ((state.model is List) && (state.model as List).isEmpty);

    final baseWidget = emptyModel ? notFound : builder(context, state.model!);

    return onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: baseWidget!,
          )
        : baseWidget!;
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
