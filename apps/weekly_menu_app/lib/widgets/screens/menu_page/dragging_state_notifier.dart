import 'package:common/date.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DraggingOverWidgetStateNotifier extends StateNotifier<Map<Date, bool>> {
  DraggingOverWidgetStateNotifier() : super({});

  void setDrag(Date? date) {
    if (date == null) return;
    final stateCopy = {...state};

    for (final k in stateCopy.keys) {
      if (state[k] != false) stateCopy[k] = false;
    }

    stateCopy[date] = true;
    state = state;
  }
}
