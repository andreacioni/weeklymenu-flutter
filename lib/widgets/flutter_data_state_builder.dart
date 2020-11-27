import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:flutter_data_state/flutter_data_state.dart';

import 'login_screen/screen.dart';

class FlutterDataStateBuilder<T> extends StatelessWidget {
  final DataStateNotifier<T> Function() notifier;
  final DataStateWidgetBuilder<T> builder;

  FlutterDataStateBuilder({this.notifier, this.builder});
  @override
  Widget build(BuildContext context) {
    return DataStateBuilder<T>(
      notifier: notifier,
      builder: (context, state, notifier, child) {
        if (state.isLoading && !state.hasModel) {
          return Center(child: CircularProgressIndicator());
        }

        if (state.hasException) {
          final ex = state.exception;
          if (ex is DioError && (ex.response.statusCode == 401) ||
              (ex is DataException && ex.statusCode == 403)) {
            Future.delayed(Duration.zero, () => goToLoginPage(context));
            return Center(child: CircularProgressIndicator());
          } else if (!state.hasModel) {
            return Text("Error occurred");
          }
        }

        return RefreshIndicator(
          onRefresh: () => notifier.reload(),
          child: builder(context, state, notifier, child),
        );
      },
    );
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
