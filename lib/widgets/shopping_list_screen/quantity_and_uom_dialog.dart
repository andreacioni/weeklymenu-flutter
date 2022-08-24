import 'package:flutter/material.dart';

import '../../models/shopping_list.dart';
import '../base_dialog.dart';
import '../shared/quantity_and_uom_input_fields.dart';

class QuantityAndUomDialog extends StatefulWidget {
  final ShoppingListItem item;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  QuantityAndUomDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<QuantityAndUomDialog> createState() => _QuantityAndUomDialogState();
}

class _QuantityAndUomDialogState extends State<QuantityAndUomDialog> {
  late ShoppingListItem newItem;

  @override
  void initState() {
    newItem = widget.item.copyWith();
    Future.delayed(Duration.zero, () => FocusScope.of(context).nextFocus());
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
              quantity: widget.item.quantity,
              unitOfMeasure: widget.item.unitOfMeasure,
              onQuantitySaved: (q) => _onSaveQuantity(q),
              onUnitOfMeasureSaved: (u) => _onSavedUom(u),
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

  void _onSaveQuantity(double? quantity) {
    newItem = newItem.copyWith(quantity: quantity);
  }

  void _onSavedUom(String? unitOfMeasure) {
    newItem = newItem.copyWith(unitOfMeasure: unitOfMeasure);
  }
}
