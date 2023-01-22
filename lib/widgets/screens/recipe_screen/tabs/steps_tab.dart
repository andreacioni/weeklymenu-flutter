import 'dart:math';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/shared/empty_page_placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';

import '../../../../models/recipe.dart';
import '../notifier.dart';

class RecipeStepsTab extends HookConsumerWidget {
  const RecipeStepsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final preparationSteps = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.preparationSteps));

    final newStepMode =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.newStepMode));

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));

    Widget buildStepCard({
      RecipePreparationStep? step,
      required int index,
      bool autofocus = false,
    }) {
      return _StepCard(
        step,
        key: ValueKey(step),
        index: index,
        autofocus: autofocus,
        editEnabled: editEnabled,
        onSubmit: (recipePreparationStep) {
          notifier.newStepMode = false;

          if (recipePreparationStep.description?.isNotEmpty ?? false) {
            if (step == null) {
              notifier.addStep(recipePreparationStep);
            }

            Future.delayed(
                Duration(milliseconds: 100), () => notifier.newStepMode = true);
          }
        },
        onChanged: (recipePreparationStep) {
          if (step != null) {
            notifier.updateStepByIndex(index, recipePreparationStep);
          }
        },
        onDelete: () {
          if (step != null) {
            notifier.deleteStepByIndex(index);
          } else {
            notifier.newStepMode = false;
          }
        },
        onFocusChanged: (hasFocus) {
          if (!hasFocus) {
            notifier.newStepMode = false;
          }
        },
      );
    }

    Widget buildAddStepCard(int currentStep) {
      return buildStepCard(autofocus: true, index: currentStep);
    }

    List<Widget> buildStepsList(List<RecipePreparationStep> steps) {
      return steps.mapIndexed((idx, step) {
        return buildStepCard(step: step, index: idx);
      }).toList();
    }

    if (!newStepMode && preparationSteps.isEmpty) {
      return EmptyPagePlaceholder(
        icon: Icons.add_circle_outline_sharp,
        text: 'No steps defined',
        sizeRate: 0.8,
        margin: EdgeInsets.only(top: 100),
      );
    } else {
      return ReorderableListView(
        shrinkWrap: true,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex = max(newIndex - 1, 0);
          }
          notifier.swapStepsByIndex(oldIndex, newIndex);
        },
        children: [
          if (preparationSteps.isNotEmpty) ...buildStepsList(preparationSteps),
          if (newStepMode) buildAddStepCard(preparationSteps.length),
        ],
      );
    }
  }
}

class _StepCard extends HookConsumerWidget {
  final RecipePreparationStep? step;
  final int? index;

  final bool autofocus;
  final bool editEnabled;
  final void Function(bool)? onFocusChanged;
  final void Function(RecipePreparationStep)? onSubmit;
  final void Function(RecipePreparationStep)? onChanged;
  final void Function()? onDelete;

  const _StepCard(
    this.step, {
    Key? key,
    this.index,
    this.onFocusChanged,
    this.onSubmit,
    this.onChanged,
    this.onDelete,
    this.autofocus = false,
    this.editEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useTextEditingController(text: step?.description);

    final focusNode = useFocusNode();
    final hasFocus = useState(false);

    useEffect((() {
      void listener() {
        hasFocus.value = focusNode.hasFocus;
        onFocusChanged?.call(focusNode.hasFocus);
      }

      focusNode.addListener(listener);

      return () => focusNode.removeListener(listener);
    }), const []);

    return ListTile(
        leading: _buildLeadingContent(theme),
        title: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 10,
              focusNode: focusNode,
              textInputAction: TextInputAction.done,
              readOnly: !editEnabled,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: _buildSuffixIcon(
                    editEnabled: editEnabled,
                    hasFocus: hasFocus.value,
                  )),
              onSubmitted: (text) => _onSubmit(text: text),
              onChanged: (text) {
                if (step != null) {
                  onChanged?.call(step!.copyWith(description: text));
                } else {
                  onChanged?.call(RecipePreparationStep(description: text));
                }
              },
            ),
          ),
        ));
  }

  void _onSubmit({String? text, TextEditingController? controller}) {
    if (text == null) {
      text = controller?.text;
    }

    if (step != null) {
      onSubmit?.call(step!.copyWith(description: text?.trim()));
    } else {
      onSubmit?.call(RecipePreparationStep(description: text?.trim()));
    }
  }

  Widget? _buildSuffixIcon(
      {required bool editEnabled,
      required bool hasFocus,
      TextEditingController? controller}) {
    if (editEnabled) {
      if (hasFocus) {
        return IconButton(
            icon: Icon(Icons.done),
            onPressed: () => _onSubmit(controller: controller));
      } else {
        return IconButton(icon: Icon(Icons.close), onPressed: onDelete);
      }
    }
  }

  Widget _buildLeadingContent(ThemeData theme) {
    if (!editEnabled) {
      return Material(
        shape: CircleBorder(),
        elevation: theme.cardTheme.elevation!,
        child: CircleAvatar(
          child: Text(((index ?? 0) + 1).toString(),
              style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black87)),
        ),
      );
    } else {
      return Icon(Icons.menu);
    }
  }
}
