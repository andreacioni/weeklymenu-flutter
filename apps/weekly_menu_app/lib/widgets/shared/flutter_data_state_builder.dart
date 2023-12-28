import 'dart:async';
import 'dart:developer';

import 'package:common/log.dart';
import 'package:data/data.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Repository;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screens/login_screen/screen.dart';

class RepositoryStreamBuilder<T> extends HookConsumerWidget {
  final Stream<T?> stream;
  final Future<void> Function()? onRefresh;
  final Widget? notFound;
  final Widget loading;
  final Widget error;
  final Widget Function(BuildContext context, T model) builder;

  const RepositoryStreamBuilder(
      {required this.stream,
      required this.builder,
      this.onRefresh,
      this.notFound = const Text('not found'),
      this.error = const Text('error'),
      this.loading = const Center(child: CircularProgressIndicator())});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<T?>(
        stream: stream,
        builder: ((context, snapshot) {
          if (snapshot.error != null) {
            //early catch the forbidden/unauthorized to redirect user to login page
            if (snapshot.error is DataException) {
              final ex = snapshot.error as DataException;
              if (ex.statusCode == 403 || ex.statusCode == 401) {
                Future.delayed(Duration.zero, () => goToLoginPage(context));
                return loading;
              }
            }

            // for other errors shows popup ?
            log(
                "RepositoryStreamBuilder caught an error: " +
                    (snapshot.error.toString()),
                level: Level.SEVERE.value,
                error: snapshot.error);

            return error;
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return loading;
          }

          final emptyModel = snapshot.data == null ||
              ((snapshot.data is List) && (snapshot.data as List).isEmpty);

          final baseWidget =
              emptyModel ? notFound : builder(context, snapshot.data!);

          return onRefresh != null
              ? RefreshIndicator(
                  onRefresh: onRefresh!,
                  child: baseWidget!,
                )
              : baseWidget!;
        }));
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}

class RepositoryFutureBuilder<T> extends HookConsumerWidget {
  final Future<T?> future;
  final Widget? notFound;
  final Widget loading;
  final Widget error;
  final Widget Function(BuildContext context, T model) builder;

  RepositoryFutureBuilder(
      {required this.future,
      required this.builder,
      this.notFound = const Text('not found'),
      this.error = const Text('error'),
      this.loading = const Center(child: CircularProgressIndicator())});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<T?>(
        future:  future,
        builder: ((context, snapshot) {
          if (snapshot.error != null) {
            //early catch the forbidden/unauthorized to redirect user to login page
            if (snapshot.error is DataException) {
              final ex = snapshot.error as DataException;
              if (ex.statusCode == 403 || ex.statusCode == 401) {
                Future.delayed(Duration.zero, () => goToLoginPage(context));
                return loading;
              }
            }

            // for other errors shows popup ?
            log(
                "RepositoryStreamBuilder caught an error: " +
                    (snapshot.error.toString()),
                level: Level.SEVERE.value,
                error: snapshot.error);

            return error;
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return loading;
          }

          final emptyModel = snapshot.data == null ||
              ((snapshot.data is List) && (snapshot.data as List).isEmpty);

          final baseWidget =
              emptyModel ? notFound : builder(context, snapshot.data!);

          return baseWidget!;
        }));
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}

class DataRepositoryStreamBuilder<T extends Data<T>>
    extends HookConsumerWidget {
  final Stream<Data<T?>> stream;
  final Future<void> Function()? onRefresh;
  final Widget? notFound;
  final Widget loading;
  final Widget error;
  final Widget Function(BuildContext context, T model) builder;

  DataRepositoryStreamBuilder(
      {required this.stream,
      required this.builder,
      this.onRefresh,
      this.notFound = const Text('not found'),
      this.error = const Text('error'),
      this.loading = const Center(child: CircularProgressIndicator())});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<Data<T?>>(
        stream: stream,
        builder: ((context, snapshot) {
          if (snapshot.error != null) {
            //early catch the forbidden/unauthorized to redirect user to login page
            if (snapshot.error is DataException) {
              final ex = snapshot.error as DataException;
              if (ex.statusCode == 403 || ex.statusCode == 401) {
                Future.delayed(Duration.zero, () => goToLoginPage(context));
                return loading;
              }
            }

            // for other errors shows popup ?
            logError(
                "RepositoryStreamBuilder caught an error: " +
                    (snapshot.error.toString()),
                snapshot.error!,
                snapshot.stackTrace!);

            return error;
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return loading;
          }

          final emptyModel = snapshot.data == null ||
              ((snapshot is List) && (snapshot as List).isEmpty);

          final baseWidget =
              emptyModel ? notFound : builder(context, snapshot.data!.content!);

          return onRefresh != null
              ? RefreshIndicator(
                  onRefresh: onRefresh!,
                  child: baseWidget!,
                )
              : baseWidget!;
        }));
  }

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
