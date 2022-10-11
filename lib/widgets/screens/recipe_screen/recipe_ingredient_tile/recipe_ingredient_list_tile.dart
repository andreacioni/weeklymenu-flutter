import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_menu_app/widgets/screens/recipe_screen/recipe_ingredient_tile/ingredient_suggestion_text_field.dart';
import 'package:weekly_menu_app/widgets/shared/base_dialog.dart';

import '../../../../main.data.dart';
import '../../../shared/flutter_data_state_builder.dart';
import '../../../shared/quantity_and_uom_input_fields.dart';
import '../recipe_ingredient_modal/recipe_ingredient_modal.dart';
import '../../../../models/ingredient.dart';
import '../../../../models/recipe.dart';

class RecipeIngredientListTile extends HookConsumerWidget {
  final RecipeIngredient? recipeIngredient;
  final bool editEnabled;
  final bool autofocus;
  final double? servingsMultiplierFactor;
  final Function(RecipeIngredient)? onChanged;

  RecipeIngredientListTile({
    this.recipeIngredient,
    this.servingsMultiplierFactor,
    this.editEnabled = false,
    this.autofocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsRepo = ref.ingredients;

    if (recipeIngredient != null) {
      return FlutterDataStateBuilder<Ingredient>(
        state: ingredientsRepo.watchOne(recipeIngredient!.ingredientId),
        notFound: _RecipeIngredientListTile(),
        builder: (context, model) {
          final ingredient = model;

          return _RecipeIngredientListTile(
            ingredient: ingredient,
            recipeIngredient: recipeIngredient,
            editEnabled: editEnabled,
            servingsMultiplierFactor: servingsMultiplierFactor,
            onChanged: onChanged,
          );
        },
      );
    } else {
      return _RecipeIngredientListTile();
    }
  }
}

class _RecipeIngredientListTile extends StatelessWidget {
  final RecipeIngredient? recipeIngredient;
  final Ingredient? ingredient;
  final double? servingsMultiplierFactor;
  final bool editEnabled;
  final Function(RecipeIngredient)? onChanged;

  const _RecipeIngredientListTile(
      {Key? key,
      this.recipeIngredient,
      this.servingsMultiplierFactor,
      this.ingredient,
      this.editEnabled = false,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String quantityString() {
      if (recipeIngredient?.quantity != null) {
        return ((servingsMultiplierFactor ?? 1) *
                (recipeIngredient!.quantity!.toInt()))
            .toStringAsFixed(0);
      }

      return '-';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: IngredientSuggestionTextField(
          ingredient: ingredient,
          enabled: editEnabled,
        ),
        trailing: InkWell(
          onTap: editEnabled ? () => _openUpdateDetailsDialog(context) : null,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                quantityString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              if (recipeIngredient?.unitOfMeasure != null)
                Text(
                  recipeIngredient!.unitOfMeasure ?? '-',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                ),
            ],
          ),
        ),
        leading: editEnabled ? Icon(Icons.drag_handle_rounded) : null,
      ),
    );
  }

  void _openUpdateDetailsDialog(BuildContext context) async {
    if (recipeIngredient != null) {
      final newRecipeIngredient = await showDialog<RecipeIngredient>(
        context: context,
        builder: (context) {
          return _QuantityAndUomDialog(
            recipeIngredient: recipeIngredient!,
          );
        },
      );

      if (newRecipeIngredient != null) {
        onChanged?.call(newRecipeIngredient);
      }
    }
  }
}

class _QuantityAndUomDialog extends StatefulWidget {
  final RecipeIngredient recipeIngredient;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _QuantityAndUomDialog({Key? key, required this.recipeIngredient})
      : super(key: key);

  @override
  State<_QuantityAndUomDialog> createState() => _QuantityAndUomDialogState();
}

class _QuantityAndUomDialogState extends State<_QuantityAndUomDialog> {
  late RecipeIngredient newRecipeIngredient;

  @override
  void initState() {
    newRecipeIngredient = widget.recipeIngredient.copyWith();
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
              quantity: widget.recipeIngredient.quantity,
              unitOfMeasure: widget.recipeIngredient.unitOfMeasure,
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
      Navigator.of(context).pop(newRecipeIngredient);
    }
  }

  void _onSaveQuantity(double? quantity) {
    newRecipeIngredient = newRecipeIngredient.copyWith(quantity: quantity);
  }

  void _onSavedUom(String? unitOfMeasure) {
    newRecipeIngredient =
        newRecipeIngredient.copyWith(unitOfMeasure: unitOfMeasure);
  }
}
