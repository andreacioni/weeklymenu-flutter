import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;

import '../../globals/constants.dart';
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
  final ShoppingListItem shoppingListItem;
  final bool editable;
  final bool selected;
  final bool displayLeading;
  final bool displayTrailing;
  final void Function(Object? value)? onSubmitted;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final void Function(bool? newValue)? onCheckChange;

  final void Function(DismissDirection) onDismiss;

  ShoppingListItemTile(
    this.shoppingListItem, {
    Key? key,
    this.editable = true,
    this.selected = false,
    this.displayLeading = true,
    this.displayTrailing = true,
    this.onSubmitted,
    required this.onDismiss,
    this.onLongPress,
    this.onTap,
    this.onCheckChange,
  }) : super(key: key);

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
          key: ValueKey(
              'Dismissible_ShoppingListItemTile_${shoppingListItem.id}'),
          onDismissed: onDismiss,
          child: Column(
            children: <Widget>[
              _ShoppingListItemTile(
                item: model,
                shoppingListItem: shoppingListItem,
                supermarketSection: supermarketSection,
                onSubmitted: onSubmitted,
                onTap: onTap,
                onLongPress: onLongPress,
                onCheckChange: onCheckChange,
                editable: editable,
                selected: selected,
                displayLeading: displayLeading,
                displayTrailing: displayTrailing,
              ),
              Divider(height: 0)
            ],
          ),
        );
      },
    );
  }
}

class _ShoppingListItemTile extends StatelessWidget {
  const _ShoppingListItemTile({
    Key? key,
    required this.item,
    required this.shoppingListItem,
    required this.supermarketSection,
    required this.onSubmitted,
    this.onLongPress,
    this.onTap,
    this.onCheckChange,
    this.selected = false,
    this.editable = false,
    this.displayLeading = true,
    this.displayTrailing = true,
  }) : super(key: key);

  final Ingredient item;
  final ShoppingListItem shoppingListItem;
  final SupermarketSection? supermarketSection;
  final void Function(Object? value)? onSubmitted;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final void Function(bool? newValue)? onCheckChange;
  final bool editable;
  final bool selected;
  final bool displayLeading;
  final bool displayTrailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      contentPadding: EdgeInsets.only(right: 16),
      onLongPress: onLongPress,
      onTap: onTap,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(color: supermarketSection?.color, width: 6),
          SizedBox(width: 10),
          if (displayLeading)
            Container(
              width: 60,
              child: _QuantityAndUomLead(shoppingListItem),
            ),
        ],
      ),
      //minLeadingWidth: 50,
      trailing: displayTrailing
          ? Checkbox(
              value: shoppingListItem.checked,
              onChanged: onCheckChange,
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 8,
            child: ItemSuggestionTextField(
              value: item,
              enabled: editable,
              onSubmitted: onSubmitted,
              //autofocus: true,
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

class _QuantityAndUomLead extends HookConsumerWidget {
  final ShoppingListItem shoppingListItem;

  const _QuantityAndUomLead(this.shoppingListItem, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var quantity = shoppingListItem.quantity;
    var uom = shoppingListItem.unitOfMeasure;

    final shoppingListId = ref.read(firstShoppingListIdProvider).value;

    void changeQuantityAndUom() async {
      final newItem = await showDialog<ShoppingListItem?>(
          context: context,
          builder: (context) {
            return _QuantityAndUomDialog(item: shoppingListItem);
          });

      if (newItem != null) {
        newItem.save(params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: changeQuantityAndUom,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (quantity != null)
              Expanded(
                child: AutoSizeText(
                  (quantity.toInt().toString() + ' ' + (uom?.toString() ?? '')),
                  textAlign: TextAlign.center,
                  wrapWords: false,
                  minFontSize: 1,
                  maxFontSize: 40,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            if (quantity == null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.more_horiz),
              ),
          ],
        ),
      ),
    );
  }
}
