import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../globals/extensions.dart';
import 'ingredient_suggestion_text_field.dart';
import '../../../shared/base_dialog.dart';
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
  final Function(dynamic)? onChanged;
  final Function(bool)? onFocusChanged;

  RecipeIngredientListTile({
    this.recipeIngredient,
    this.servingsMultiplierFactor,
    this.editEnabled = false,
    this.autofocus = false,
    this.onChanged,
    this.onFocusChanged,
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
            key: ValueKey(ingredient.name),
            ingredient: ingredient,
            recipeIngredient: recipeIngredient,
            editEnabled: editEnabled,
            servingsMultiplierFactor: servingsMultiplierFactor,
            onChanged: onChanged,
            onFocusChanged: onFocusChanged,
          );
        },
      );
    } else {
      return _RecipeIngredientListTile(
        editEnabled: editEnabled,
        servingsMultiplierFactor: servingsMultiplierFactor,
        autofocus: true,
        onChanged: onChanged,
        onFocusChanged: onFocusChanged,
      );
    }
  }
}

class _RecipeIngredientListTile extends StatelessWidget {
  final RecipeIngredient? recipeIngredient;
  final Ingredient? ingredient;
  final double? servingsMultiplierFactor;
  final bool editEnabled;
  final bool autofocus;
  final Function(dynamic)? onChanged;
  final Function(bool)? onFocusChanged;

  const _RecipeIngredientListTile({
    Key? key,
    this.recipeIngredient,
    this.servingsMultiplierFactor,
    this.ingredient,
    this.editEnabled = false,
    this.autofocus = false,
    this.onChanged,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String quantityString() {
      if (recipeIngredient?.quantity != null) {
        return ((servingsMultiplierFactor ?? 1) *
                (recipeIngredient!.quantity!.toInt()))
            .toStringAsFixed(0);
      }

      return '-';
    }

    return ListTile(
      title: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IngredientSuggestionTextField(
            ingredient: ingredient,
            enabled: editEnabled,
            autofocus: autofocus,
            onSubmitted: onChanged,
            onFocusChanged: onFocusChanged,
          ),
        ),
      ),
      leading: Material(
          shape: CircleBorder(),
          elevation: theme.cardTheme.elevation!,
          child: CircleAvatar(
            child: InkWell(
              onTap:
                  editEnabled ? () => _openUpdateDetailsDialog(context) : null,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      child: AutoSizeText(
                        quantityString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (!(recipeIngredient?.unitOfMeasure?.isBlank ?? true))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(
                          height: 1,
                          color: Colors.black26,
                        ),
                      ),
                    if (!(recipeIngredient?.unitOfMeasure?.isBlank ?? true))
                      Flexible(
                        child: AutoSizeText(
                          recipeIngredient!.unitOfMeasure ?? '-',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )),
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
