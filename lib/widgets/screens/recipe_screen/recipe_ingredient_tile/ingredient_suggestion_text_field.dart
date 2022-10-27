import 'dart:async';

import 'package:collection/collection.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../globals/extensions.dart';
import '../../../../models/ingredient.dart';
import '../../../../main.data.dart';

class IngredientSuggestionTextField extends HookConsumerWidget {
  final Ingredient? ingredient;

  final bool enabled;
  final bool autofocus;

  final ScrollController? scrollController;

  final int suggestAfter;

  final void Function(dynamic)? onSubmitted;
  final void Function(bool)? onFocusChanged;

  const IngredientSuggestionTextField({
    Key? key,
    this.ingredient,
    this.enabled = true,
    this.autofocus = false,
    this.suggestAfter = 1,
    this.scrollController,
    this.onSubmitted,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFocus = useState(false);
    final hasText = useState(false);

    return Autocomplete<Ingredient>(
      initialValue: TextEditingValue(text: ingredient?.name ?? ''),
      optionsMaxHeight: 100,
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.length < suggestAfter ||
            !enabled ||
            textEditingValue.text == ingredient?.name)
          return const <Ingredient>[];

        final ingredients =
            await ref.ingredients.findAll(remote: false) ?? <Ingredient>[];

        return ingredients.where((i) =>
            i.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (option) => option.name,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        focusNode.addListener(() {
          hasFocus.value = focusNode.hasPrimaryFocus;

          if (!focusNode.hasPrimaryFocus) {
            textEditingController.text = ingredient?.name ?? '';
            textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length));
          }

          onFocusChanged?.call(focusNode.hasPrimaryFocus);
        });

        return AutoSizeTextField(
            scrollController: scrollController,
            autofocus: autofocus,
            focusNode: enabled ? focusNode : null,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingController,
            onChanged: (text) {
              hasText.value = text.isNotBlank;
            },
            readOnly: !enabled,
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: hasFocus.value && hasText.value
                    ? GestureDetector(
                        child: Icon(Icons.done),
                        onTap: () => _submit(ref, textEditingController.text),
                      )
                    : null),
            onSubmitted: (text) => _submit(ref, text));
      },
    );
  }

  void _submit(WidgetRef ref, String text) async {
    if (onSubmitted != null) {
      final ingredients =
          await ref.ingredients.findAll(remote: false) ?? <Ingredient>[];
      final ing = ingredients.firstWhereOrNull((i) => i.name.trim() == text);

      onSubmitted!(ing ?? text.trim());
    }
  }
}
