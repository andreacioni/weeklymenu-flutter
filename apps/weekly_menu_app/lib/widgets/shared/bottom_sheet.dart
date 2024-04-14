import 'dart:math';

import 'package:flutter/material.dart';

const BOTTOM_SHEET_RADIUS = const Radius.circular(10);

Future<T?> showCustomModalBottomSheet<T>(
    {required BuildContext context,
    required Widget Function(BuildContext) builder}) {
  return showModalBottomSheet<T>(
      context: context,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: BOTTOM_SHEET_RADIUS,
          topRight: BOTTOM_SHEET_RADIUS,
        ),
      ),
      useRootNavigator: true,
      isScrollControlled: true,
      builder: builder);
}

class BaseBottomSheet extends StatelessWidget {
  final Widget body;
  final VoidCallback? onTap;
  final bool loading;
  final double maxSize;

  final Icon? actionButtonIcon;
  final String actionButtonText;

  final String? appBarTitle;

  BaseBottomSheet({
    required this.body,
    required this.actionButtonText,
    this.actionButtonIcon,
    this.onTap,
    this.loading = false,
    this.appBarTitle,
    this.maxSize = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    final maxSheetHeight =
        min<double>(300 + mq.viewInsets.bottom, mq.size.height * maxSize);

    return Container(
      height: maxSheetHeight,
      child: Scaffold(
        appBar: appBarTitle != null
            ? AppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                title: Text(appBarTitle!),
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  splashRadius: 15,
                ),
              )
            : null,
        body: body,
        primary: false,
        bottomSheet: Material(
          elevation: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Spacer(flex: 8),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                    child: loading
                        ? SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              color: theme.scaffoldBackgroundColor,
                              strokeWidth: 2,
                            ))
                        : Text(actionButtonText),
                    onPressed: onTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
