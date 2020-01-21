import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';

class ExpandableWidget extends StatefulWidget {
  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
       header: Text("Lorem ipsum",
        style: Theme.of(context).textTheme.body2,
      ),
      expanded: Text("loremIpsum", softWrap: true, ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );
  }
}