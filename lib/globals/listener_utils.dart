//https://stackoverflow.com/questions/70277515/how-can-i-select-widgets-by-dragging-over-them-but-also-clicking-them-individual
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class IndexedListenerWrapper extends SingleChildRenderObjectWidget {
  final int index;

  IndexedListenerWrapper({Widget? child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  IndexedListenerWrapperRenderObject createRenderObject(BuildContext context) {
    return IndexedListenerWrapperRenderObject()..index = index;
  }

  @override
  void updateRenderObject(
      BuildContext context, IndexedListenerWrapperRenderObject renderObject) {
    renderObject..index = index;
  }
}

class IndexedListenerWrapperRenderObject extends RenderProxyBox {
  int? index;
}
