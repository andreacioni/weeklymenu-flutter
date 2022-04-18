import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'login_screen/screen.dart';

class FlutterDataStateBuilder<T extends Object> extends HookConsumerWidget {
  final DataState<T?> state;
  final Future<void> Function()? onRefresh;
  final Widget? notFound;
  final Widget loading;
  final Widget Function(BuildContext context, T model) builder;

  FlutterDataStateBuilder(
      {required this.state,
      required this.builder,
      this.notFound,
      this.onRefresh,
      this.loading = const Center(child: CircularProgressIndicator())});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        if (state.isLoading && !state.hasModel) {
          return loading;
        }

        if (state.hasException) {
          final ex = state.exception;
          if ((ex is DataException && ex.statusCode == 403) ||
              (ex is DataException && ex.statusCode == 401)) {
            Future.delayed(Duration.zero, () => goToLoginPage(context));
            return loading;
          }
        }

        final emptyModel = state.model == null ||
            ((state.model is List) && (state.model as List).isEmpty);

        final baseWidget = emptyModel && notFound != null
            ? notFound!
            : builder(context, state.model!);

        return onRefresh != null
            ? RefreshIndicator(
                onRefresh: onRefresh!,
                child: baseWidget,
              )
            : baseWidget;
      },
    );
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
