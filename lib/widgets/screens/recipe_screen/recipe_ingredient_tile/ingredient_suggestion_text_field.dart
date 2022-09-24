import 'dart:async';

import 'package:collection/collection.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/ingredient.dart';
import '../../../../main.data.dart';

class IngredientSuggestionTextField extends HookConsumerWidget {
  final Ingredient? ingredient;

  final bool enabled;
  final bool autofocus;

  final int suggestAfter;

  final void Function(dynamic)? onSubmitted;
  final void Function(bool)? onFocusChanged;

  const IngredientSuggestionTextField({
    Key? key,
    this.ingredient,
    this.enabled = true,
    this.autofocus = false,
    this.suggestAfter = 1,
    this.onSubmitted,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Autocomplete<Object>(
      initialValue: TextEditingValue(text: ingredient?.name ?? ''),
      optionsMaxHeight: 150,
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.length < suggestAfter)
          return const <String>[];
        final ingredients =
            await ref.ingredients.findAll(remote: false) ?? <Ingredient>[];

        return ingredients.map((i) => i.name).where((i) =>
            i.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        focusNode
            .addListener(() => onFocusChanged?.call(focusNode.hasPrimaryFocus));
        return AutoSizeTextField(
          autofocus: autofocus,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.sentences,
          controller: textEditingController,
          enabled: enabled,
          onSubmitted: onSubmitted != null
              ? (text) async {
                  final ingredients =
                      await ref.ingredients.findAll(remote: false) ??
                          <Ingredient>[];
                  final ing = ingredients
                      .firstWhereOrNull((i) => i.name.trim() == text);

                  onSubmitted!(ing ?? text.trim());
                }
              : null,
        );
      },
    );
  }
}
