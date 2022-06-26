import 'package:flutter/material.dart';

class BaseDialog<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final void Function()? onDoneTap;
  final String doneButtonText;
  final List<Widget> children;

  BaseDialog(
      {required this.children,
      required this.title,
      this.subtitle,
      this.doneButtonText = 'OK',
      this.onDoneTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      insetPadding: EdgeInsets.zero,
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
        Divider(),
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
        )
      ],
    );
  }
}
