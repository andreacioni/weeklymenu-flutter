import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import '../../globals/utils.dart';
import '../../models/ingredient.dart';
import '../../models/shopping_list.dart';

class ItemSuggestionTextField extends HookConsumerWidget {
  final Ingredient? value;
  final String? hintText;
  final bool autofocus;
  final bool showShoppingItemSuggestions;
  final void Function(dynamic)? onSubmitted;
  final Function()? onTap;
  final Function(bool)? onFocusChanged;
  final bool enabled;
  final bool readOnly;
  final TextStyle? textStyle;
  final List<Ingredient> availableIngredients;

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
    required this.availableIngredients,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final scrollController = useScrollController(keepScrollOffset: false);

    useEffect(() {
      void listener() {
        onFocusChanged?.call(focusNode.hasFocus);
      }

      focusNode.addListener(listener);

      return () => focusNode.removeListener(listener);
    }, const []);

    Ingredient? resolveShoppingListItemIngredient(ShoppingListItem item) {
      return availableIngredients
          .firstWhereOrNull((ingredient) => ingredient.id == item.item);
    }

    String displayStringForOption(Object option) {
      if (option is Ingredient) {
        return option.name;
      } else if (option is ShoppingListItem) {
        return resolveShoppingListItemIngredient(option)?.name ?? 'Unknown';
      }

      return 'Unknown';
    }

    Future<Iterable<Object>> suggestionsCallback(TextEditingValue value) async {
      final ingredientsRepo = ref.read(ingredientsRepositoryProvider);
      final shopListRepo = ref.read(shoppingListsRepositoryProvider);

      List<Object> suggestions = [];

      if (showShoppingItemSuggestions) {
        final shoppingList = (await shopListRepo.findAll(remote: false))![0];

        final checkedItems = shoppingList.getCheckedItems.where((item) {
          var ing = resolveShoppingListItemIngredient(item);
          return ing != null ? stringContains(ing.name, value.text) : false;
        });

        suggestions.addAll(checkedItems);
        suggestions.addAll(availableIngredients
            .where((ing) =>
                stringContains(ing.name, value.text) &&
                shoppingList.containsItem(ing.id) == false)
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
        var ing = resolveShoppingListItemIngredient(item);
        return ListTile(
          title: Text(ing?.name ?? 'Ingredient not found'),
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
        return AutoSizeTextField(
          controller: textEditingController,
          focusNode: focusNode,
          autofocus: autofocus,
          enabled: enabled,
          readOnly: readOnly,
          minLines: 1,
          maxLines: 2,
          style: textStyle,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          scrollController: scrollController,
          //fullwidth: true,
          onSubmitted: (txt) => onSubmitted?.call(txt),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          onEditingComplete: () {
            onSubmitted?.call(textEditingController.text);
          },
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
