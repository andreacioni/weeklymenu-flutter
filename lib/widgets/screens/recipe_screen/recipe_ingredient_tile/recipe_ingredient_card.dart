import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/ingredient.dart';
import 'ingredient_suggestion_text_field.dart';

class IngredientCard extends HookConsumerWidget {
  final Ingredient? ingredient;
  final double? quantity;
  final String? unitOfMeasure;

  final void Function()? onEditTap;

  IngredientCard({
    this.ingredient,
    this.quantity,
    this.unitOfMeasure,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: IngredientSuggestionTextField(
          ingredient: ingredient,
        ),
        trailing: InkWell(
          onTap: onEditTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                quantity?.toStringAsFixed(0) ?? '-',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                unitOfMeasure ?? '-',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
