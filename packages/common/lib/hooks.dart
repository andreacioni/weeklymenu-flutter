import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

T useStateNotifier<T>(StateNotifier<T> notifier) {
  final state = useState<T?>(null);

  useEffect(() {
    return notifier.addListener((s) => state.value = s);
  }, [notifier]);

  return state.value!;
}
