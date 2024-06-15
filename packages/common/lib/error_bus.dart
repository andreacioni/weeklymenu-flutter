import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

final errorBusProvider = Provider<ErrorBus>((_) => ErrorBus());
final errorBusStreamProvider =
    StreamProvider<ErrorBusEvent>((ref) => ref.read(errorBusProvider).stream);

class ErrorBusEvent {
  final Object error;
  final String friendlyMessage;
  ErrorBusEvent(this.error, this.friendlyMessage);
}

class ErrorBus {
  final _controller = StreamController<ErrorBusEvent>.broadcast();

  Stream<ErrorBusEvent> get stream => _controller.stream;

  void addError(Object error, String friendlyMessage) {
    _controller.add(ErrorBusEvent(error, friendlyMessage));
  }

  void close() {
    _controller.close();
  }
}
