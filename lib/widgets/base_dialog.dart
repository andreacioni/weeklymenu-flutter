import 'package:flutter/material.dart';

class BaseDialog<T> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      title: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: theme.dialogTheme.titleTextStyle,
            ),
            Text('Subtitle',
                style: theme.dialogTheme.titleTextStyle!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54)),
            Divider()
          ]),
      children: [
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () {}, child: Text('CANCEL')),
            SizedBox(width: 10),
            ElevatedButton(onPressed: () {}, child: Text('OK'))
          ],
        )
      ],
    );
  }
}
