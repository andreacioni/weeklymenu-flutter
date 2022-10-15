import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/shared/empty_page_placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../models/recipe.dart';
import '../../../../providers/screen_notifier.dart';
import '../../../shared/editable_text_field.dart';
import '../../../../globals/utils.dart';

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

    Widget buildStepCard(
        {RecipePreparationStep? step, int? index, bool autofocus = false}) {
      return _StepCard(
        step,
        key: ValueKey(step),
        index: index,
        autofocus: autofocus,
        onSubmit: (recipePreparationStep) {
          notifier.addStep(recipePreparationStep);
        },
        onFocusChanged: (hasFocus) {
          if (!hasFocus) {
            notifier.newStepMode = false;
          }
        },
      );
    }

    Widget buildAddStepCard(int currentStep) {
      return buildStepCard(autofocus: true, index: currentStep + 1);
    }

    List<Widget> buildStepsList(List<RecipePreparationStep> steps) {
      return steps.mapIndexed((step, idx) {
        return buildStepCard(step: step, index: idx + 1);
      }).toList();
    }

    return Column(
      children: [
        if (!newStepMode && preparationSteps.isEmpty)
          EmptyPagePlaceholder(
            icon: Icons.add_circle_outline_sharp,
            text: 'No steps defined',
            sizeRate: 0.8,
            margin: EdgeInsets.only(top: 100),
          ),
        if (preparationSteps.isNotEmpty) ...buildStepsList(preparationSteps),
        if (newStepMode) buildAddStepCard(preparationSteps.length),
        /* SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            "Notes",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        EditableTextField(
          recipe.note,
          editEnabled: editEnabled,
          hintText: "Add note...",
          maxLines: 1000,
          onSaved: (text) =>
              originator.update(originator.instance.copyWith(note: text)),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            "Tags",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        RecipeTags(
          recipe: originator,
          editEnabled: editEnabled,
        ),
        SizedBox(
          height: 20,
        ), */
      ],
    );
  }
}

class _StepCard extends HookConsumerWidget {
  final RecipePreparationStep? step;
  final int? index;

  final bool autofocus;
  final void Function(bool)? onFocusChanged;
  final void Function(RecipePreparationStep)? onSubmit;

  const _StepCard(
    this.step, {
    Key? key,
    this.index,
    this.onFocusChanged,
    this.onSubmit,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useTextEditingController(text: step?.description);
    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));

    final focusNode = useFocusNode();

    useEffect((() {
      void listener() {
        onFocusChanged?.call(focusNode.hasFocus);
      }

      focusNode.addListener(listener);

      return () => focusNode.removeListener(listener);
    }), const []);

    return ListTile(
        leading: Material(
            shape: CircleBorder(),
            elevation: theme.cardTheme.elevation!,
            child: CircleAvatar(
              child: Text(index.toString(),
                  style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black87)),
            )),
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
              decoration: InputDecoration(border: InputBorder.none),
              onSubmitted: (text) {
                if (step != null) {
                  onSubmit?.call(step!.copyWith());
                }
                onSubmit?.call(RecipePreparationStep(description: text));
              },
            ),
          ),
        ));
  }
}
