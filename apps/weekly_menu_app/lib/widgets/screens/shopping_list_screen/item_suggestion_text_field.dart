import 'dart:developer';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:common/utils.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:model/ingredient.dart';
import 'package:model/shopping_list.dart';
import 'package:collection/collection.dart';

import 'notifier.dart';

class ItemSuggestionTextField extends HookConsumerWidget {
  final ShoppingListItem? value;
  final String? hintText;
  final bool autofocus;
  final bool showShoppingItemSuggestions;
  final void Function(dynamic)? onSubmitted;
  final Function()? onTap;
  final Function(bool)? onFocusChanged;
  final bool enabled;
  final bool readOnly;
  final TextStyle? textStyle;

  ItemSuggestionTextField({
    this.value,
    this.onSubmitted,
    this.showShoppingItemSuggestions = true,
    this.onTap,
    this.autofocus = false,
    this.enabled = true,
    this.onFocusChanged,
    this.readOnly = false,
    this.hintText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController(keepScrollOffset: false);

    //TODO remove dependency to ref in this widget
    final shoppingListItems = !enabled
        ? <ShoppingListItem>[]
        : ref.read(shoppingListScreenNotifierProvider).allItems;
    final ingredientsRepository = ref.watch(ingredientsRepositoryProvider);

    String displayStringForOption(Object option) {
      if (option is Ingredient) {
        return option.name;
      } else if (option is ShoppingListItem) {
        return option.itemName;
      }
      log('failed to print the shopping list item name: $option',
          level: Level.SEVERE.value);
      return '';
    }

    Future<Iterable<Object>> suggestionsCallback(TextEditingValue value) async {
      List<Object> suggestions = [];

      final availableIngredients = await ingredientsRepository.loadAll();

      if (showShoppingItemSuggestions) {
        final checkedItems = shoppingListItems.where((item) {
          return item.checked && stringContains(item.itemName, value.text);
        });

        suggestions.addAll(checkedItems);
        suggestions.addAll(availableIngredients
            .where((ing) =>
                stringContains(ing.name, value.text) &&
                shoppingListItems.firstWhereOrNull(
                        (i) => i.itemName.trim() == ing.name.trim()) ==
                    null)
            .toList());
      } else {
        suggestions.addAll(availableIngredients
            .where((ing) => stringContains(ing.name, value.text))
            .toList());
      }

      return suggestions;
    }

    Widget itemBuilder(BuildContext context, Object? item) {
      if (item is Ingredient) {
        return ListTile(
          title: Text(item.name),
          subtitle: Text('Ingredient'),
        );
      } else if (item is ShoppingListItem) {
        return ListTile(
          title: Text(item.itemName),
          subtitle: Text('Shopping List'),
          trailing: Icon(Icons.check_box),
        );
      }

      return ListTile(
        title: Text('Unknown'),
        subtitle: Text('That is unexpected'),
        trailing: Icon(Icons.error_outline),
      );
    }

    return Autocomplete<Object>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        focusNode.addListener(() => onFocusChanged?.call(focusNode.hasFocus));

        return AutoSizeTextField(
          controller: textEditingController,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          readOnly: readOnly,
          minLines: 1,
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          style: textStyle,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          scrollController: scrollController,
          onSubmitted: (txt) => onSubmitted?.call(txt),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          /*onEditingComplete: () {
          onSubmitted?.call(textEditingController.text);
        },*/
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            hintText: hintText,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isDense: true,
          ),
        );
      },
      onSelected: (selected) => onSubmitted?.call(selected),
      initialValue: value != null
          ? TextEditingValue(text: displayStringForOption(value!))
          : null,
      optionsBuilder: suggestionsCallback,
      optionsViewBuilder: (
        context,
        onSelected,
        options,
      ) {
        return _CustomAutocompleteOptions<Object>(
          onSelected: onSelected,
          options: options,
          itemBuilder: itemBuilder,
        );
      },
      displayStringForOption: displayStringForOption,
    );
  }
}

// derived from the original _AutocompleteOptions
class _CustomAutocompleteOptions<T extends Object> extends StatelessWidget {
  const _CustomAutocompleteOptions(
      {Key? key,
      this.displayStringForOption,
      required this.onSelected,
      required this.options,
      this.maxOptionsHeight = 200,
      required this.itemBuilder})
      : super(key: key);

  final AutocompleteOptionToString<T>? displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;

  final Widget Function(BuildContext context, T option)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);

              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: itemBuilder != null
                        ? itemBuilder!(context, option)
                        : _defaultItem(option),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Text _defaultItem(option) {
    return Text(
      displayStringForOption == null
          ? option.toString()
          : displayStringForOption!(option),
    );
  }
}
