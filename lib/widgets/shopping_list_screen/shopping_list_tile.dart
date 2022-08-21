import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;

import '../../models/user_preferences.dart';
import '../../providers/user_preferences.dart';
import '../base_dialog.dart';
import 'screen.dart';
import '../flutter_data_state_builder.dart';
import '../../models/shopping_list.dart';
import '../../models/ingredient.dart';
import '../shared/quantity_and_uom_input_fields.dart';
import './item_suggestion_text_field.dart';
import '../../main.data.dart';

class ShoppingListItemTile extends HookConsumerWidget {
  final Key formKey;
  final ShoppingListItem shoppingListItem;
  final bool editable;
  final void Function(Object? value)? onSubmitted;
  final void Function(DismissDirection)? onDismiss;
  final List<Ingredient> availableIngredients;

  ShoppingListItemTile(
    this.shoppingListItem, {
    required this.formKey,
    required this.availableIngredients,
    this.editable = true,
    this.onSubmitted,
    this.onDismiss,
  }) : super(key: formKey);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsRepository = ref.ingredients;
    final selectedItems = ref.read(selectedShoppingListItemsProvider);
    final supermarketSection = ref.read(supermarketSectionByNameProvider(
        shoppingListItem.supermarketSectionName));

    return FlutterDataStateBuilder<Ingredient>(
      state: ingredientsRepository.watchOne(shoppingListItem.item),
      onRefresh: () => ingredientsRepository.findOne(shoppingListItem.item),
      builder: (context, model) {
        return Dismissible(
          direction: selectedItems.isNotEmpty
              ? DismissDirection.none
              : DismissDirection.endToStart,
          key: formKey,
          onDismissed: onDismiss,
          child: Column(
            children: <Widget>[
              _ShoppingListItemTile(
                item: model,
                shoppingListItem: shoppingListItem,
                supermarketSection: supermarketSection,
                onSubmitted: onSubmitted,
                availableIngredients: availableIngredients,
                editable: editable,
              ),
              Divider(height: 0)
            ],
          ),
        );
      },
    );
  }
}

class _ShoppingListItemTile extends HookConsumerWidget {
  const _ShoppingListItemTile({
    Key? key,
    required this.item,
    required this.shoppingListItem,
    required this.supermarketSection,
    required this.onSubmitted,
    required this.availableIngredients,
    required this.editable,
  }) : super(key: key);

  final Ingredient item;
  final ShoppingListItem shoppingListItem;
  final SupermarketSection? supermarketSection;
  final void Function(Object? value)? onSubmitted;
  final List<Ingredient> availableIngredients;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.read(selectedShoppingListItemsProvider);

    void toggleItemToSelectedItems(String itemId) {
      if (!selectedItems.contains(itemId)) {
        ref
            .read(selectedShoppingListItemsProvider.notifier)
            .update((state) => [...state, itemId]);
      } else {
        ref
            .read(selectedShoppingListItemsProvider.notifier)
            .update((state) => [...state..removeWhere((e) => e == itemId)]);
      }
    }

    return ListTile(
      selected: selectedItems.contains(shoppingListItem.item),
      contentPadding: EdgeInsets.only(right: 16),
      onLongPress: () => toggleItemToSelectedItems(shoppingListItem.item),
      onTap: selectedItems.isNotEmpty
          ? () => toggleItemToSelectedItems(shoppingListItem.item)
          : null,
      leading: Container(color: supermarketSection?.color, width: 6),
      minLeadingWidth: 6,
      trailing: selectedItems.isEmpty
          ? Checkbox(
              value: shoppingListItem.checked,
              onChanged: onSubmitted,
            )
          : null,
      title: Row(
        children: [
          if (selectedItems.isEmpty) _QuantityAndUomChip(shoppingListItem),
          const SizedBox(width: 10),
          Flexible(
            flex: 8,
            child: ItemSuggestionTextField(
              availableIngredients: availableIngredients,
              value: item,
              enabled: editable,
              showShoppingItemSuggestions: false,
              onSubmitted: onSubmitted,
              textStyle: shoppingListItem.checked
                  ? TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey)
                  : null,
            ),
          ),
          //some space to allow swipe to dismiss
          Flexible(flex: 1, child: Container()),
        ],
      ),
    );
  }
}

class _QuantityAndUomDialog extends StatefulWidget {
  final ShoppingListItem item;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _QuantityAndUomDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<_QuantityAndUomDialog> createState() => _QuantityAndUomDialogState();
}

class _QuantityAndUomDialogState extends State<_QuantityAndUomDialog> {
  late ShoppingListItem newItem;

  @override
  void initState() {
    newItem = widget.item.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: BaseDialog(
        title: 'Quantity',
        subtitle: 'Choose the quantity and the unit of measure',
        children: [
          Container(
            child: QuantityAndUnitOfMeasureInputFormField(
              quantity: widget.item.quantity ?? 0,
              unitOfMeasure: widget.item.unitOfMeasure,
              onQuantitySaved: (q) => _onSaved(quantity: q),
              onUnitOfMeasureSaved: (u) => _onSaved(unitOfMeasure: u),
            ),
          )
        ],
        onDoneTap: () => _onDone(context),
      ),
    );
  }

  void _onDone(BuildContext context) {
    if (widget._formKey.currentState?.validate() ?? false) {
      widget._formKey.currentState!.save();
      Navigator.of(context).pop(newItem);
    }
  }

  void _onSaved({double? quantity, String? unitOfMeasure}) {
    if (quantity != null) {
      newItem = newItem.copyWith(quantity: quantity);
    }

    if (unitOfMeasure != null) {
      newItem = newItem.copyWith(unitOfMeasure: unitOfMeasure);
    }
  }
}

class _QuantityAndUomChip extends HookConsumerWidget {
  final ShoppingListItem shoppingListItem;

  const _QuantityAndUomChip(this.shoppingListItem, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var quantity = shoppingListItem.quantity;
    var uom = shoppingListItem.unitOfMeasure;

    final shoppingListId = ref.read(firstShoppingListIdProvider).value;

    void _changeQuantityAndUom() async {
      final newItem = await showDialog<ShoppingListItem?>(
          context: context,
          builder: (context) {
            return _QuantityAndUomDialog(item: shoppingListItem);
          });

      if (newItem != null) {
        newItem
            .save(params: {'update': true, 'shopping_list_id': shoppingListId});
      }
    }

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(5),
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: InkWell(
        onTap: _changeQuantityAndUom,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (quantity != null)
              Expanded(
                child: AutoSizeText(
                  (quantity.toInt().toString()),
                  textAlign: TextAlign.center,
                  wrapWords: false,
                  minFontSize: 10,
                  maxFontSize: 30,
                  softWrap: false,
                ),
              ),
            if ((quantity == null && uom == null) ||
                (quantity != null && uom != null))
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        color: Colors.black,
                      ))),
            if (quantity != null && uom != null)
              Expanded(
                child: AutoSizeText(
                  (uom.toString()),
                  textAlign: TextAlign.center,
                  wrapWords: false,
                  minFontSize: 1,
                  maxFontSize: 20,
                  softWrap: false,
                ),
              )
          ],
        ),
      ),
    );
  }
}
