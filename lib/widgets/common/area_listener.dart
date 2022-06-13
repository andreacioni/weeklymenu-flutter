import 'package:flutter/material.dart';
import 'package:weekly_menu_app/models/recipe.dart';

class AreaListener extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MouseRegion(
      //hitTestBehavior: HitTestBehavior.translucent,
      //onPointerHover: (_) => print('onPointerHover ${this.hashCode}'),
      //onPointerSignal: (_) => print('onPointerSignal ${this.hashCode}'),
      onExit: (ev) {
        /* 
        inside = false;
        setState(() => inside = false);
        */
        onLeave?.call();
        print('onLeave');
      },
      onEnter: (ev) {
        print('onLeave');
        onEnter?.call();
        /*  setState(() => inside = true);
          return false; 
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
            print('inside ${this.hashCode}');
          }
        } else {
          inside = false;
        }

        if (inside == true && wasInside == false) {
          widget.onEnter?.call();
        } else if (inside == false && wasInside == true) {
          widget.onLeave?.call();
        }*/
      },
      child: child,
    );
  }
}
