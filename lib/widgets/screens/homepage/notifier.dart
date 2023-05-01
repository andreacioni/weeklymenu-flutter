import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'notifier.g.dart';

final homepageScreenNotifierProvider = StateNotifierProvider.autoDispose<
    HomepageScreenStateNotifier,
    HomepageScreenState>((ref) => throw UnimplementedError());

@immutable
@CopyWith()
class HomepageScreenState {
  final bool isLoading;

  HomepageScreenState({this.isLoading = false});
}

class HomepageScreenStateNotifier extends StateNotifier<HomepageScreenState> {
  HomepageScreenStateNotifier(HomepageScreenState state) : super(state);

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}
