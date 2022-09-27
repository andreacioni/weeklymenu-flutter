import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weekly_menu_app/widgets/shared/empty_page_placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../models/recipe.dart';
import '../../../../providers/screen_notifier.dart';
import '../../../shared/editable_text_field.dart';
import '../../recipe_Screen/recipe_tags.dart';

class RecipeStepsTab extends HookConsumerWidget {
  const RecipeStepsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final preparationSteps = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator!.instance.preparationSteps));

    final newStepMode =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.newStepMode));

    Widget buildStepCard(
        {RecipePreparationStep? step, bool autofocus = false}) {
      return _StepCard(
        step,
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

    Widget buildAddStepCard() {
      return buildStepCard(autofocus: true);
    }

    List<Widget> buildStepsList(List<RecipePreparationStep> steps) {
      return steps.map((step) {
        return buildStepCard(step: step);
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
        if (newStepMode) buildAddStepCard(),
        if (preparationSteps.isNotEmpty) ...buildStepsList(preparationSteps)
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

  final bool autofocus;
  final void Function(bool)? onFocusChanged;
  final void Function(RecipePreparationStep)? onSubmit;

  const _StepCard(
    this.step, {
    Key? key,
    this.onFocusChanged,
    this.onSubmit,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, _) {
    final controller = useTextEditingController(text: step?.description);
    final focusNode = useFocusNode();

    useEffect((() {
      void listener() {
        onFocusChanged?.call(focusNode.hasFocus);
      }

      focusNode.addListener(listener);

      return () => focusNode.removeListener(listener);
    }), const []);

    return Card(
      child: ListTile(
          title: AutoSizeTextField(
        controller: controller,
        autofocus: autofocus,
        textCapitalization: TextCapitalization.sentences,
        minLines: 1,
        maxLines: 10,
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        onSubmitted: (text) {
          if (step != null) {
            onSubmit?.call(step!.copyWith());
          }
          onSubmit?.call(RecipePreparationStep(description: text));
        },
      )),
    );
  }
}
