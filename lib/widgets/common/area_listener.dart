import 'package:flutter/material.dart';

class AreaListener extends StatefulWidget {
  final Widget child;
  final void Function()? onEnter;
  final void Function()? onLeave;

  AreaListener({
    Key? key,
    required this.child,
    this.onEnter,
    this.onLeave,
  }) : super(key: key);

  @override
  State<AreaListener> createState() => _AreaListenerState();
}

class _AreaListenerState extends State<AreaListener> {
  final globalKey = GlobalKey();
  bool inside = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
        //behavior: HitTestBehavior.opaque,
        onPointerMove: (ev) {
          final wasInside = inside;
          final pointerPos = ev.position;
          if (globalKey.currentContext == null) {
            return;
          }
          final renderBox =
              globalKey.currentContext!.findRenderObject() as RenderBox;
          final widgetPos = renderBox.localToGlobal(Offset.zero);
          final widgetDim = renderBox.size;
          if (pointerPos.dy >= widgetPos.dy &&
              (pointerPos.dy <= widgetPos.dy + widgetDim.height)) {
            if (pointerPos.dx >= widgetPos.dx &&
                (pointerPos.dx <= widgetPos.dy + widgetDim.width)) {
              inside = true;
              print('inside');
            }
          } else {
            inside = false;
          }

          if (inside == true && wasInside == false) {
            widget.onEnter?.call();
          } else if (inside == false && wasInside == true) {
            widget.onLeave?.call();
          }
        },
        child: Container(
          key: globalKey,
          child: widget.child,
        ));
  }
}
