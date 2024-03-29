import 'package:flutter/material.dart';

class BaseDialog<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final void Function()? onDoneTap;
  final String doneButtonText;
  final bool displayActions;
  final List<Widget> children;

  BaseDialog({
    required this.title,
    required this.children,
    this.subtitle,
    this.displayActions = true,
    this.doneButtonText = 'OK',
    this.onDoneTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      title: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.dialogTheme.titleTextStyle,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 3),
              Text(
                subtitle!,
                style: theme.dialogTheme.titleTextStyle!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54),
              ),
            ],
            SizedBox(height: 5),
            Divider(height: 1)
          ]),
      children: [
        ...children,
        if (displayActions) Divider(),
        if (displayActions)
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CANCEL')),
              SizedBox(width: 10),
              ElevatedButton(onPressed: onDoneTap, child: Text(doneButtonText))
            ],
          ),
        const SizedBox(height: 10)
      ],
    );
  }
}
