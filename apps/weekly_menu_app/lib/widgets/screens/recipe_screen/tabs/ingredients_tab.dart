import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:model/ingredient.dart';
import 'package:model/recipe.dart';
import 'package:common/extensions.dart';
import 'package:weekly_menu_app/widgets/shared/flutter_data_state_builder.dart';

import '../../../shared/base_dialog.dart';
import '../../../shared/empty_page_placeholder.dart';
import '../../../shared/quantity_and_uom_input_fields.dart';
import '../../../shared/shimmer.dart';
import '../notifier.dart';

class RecipeIngredientsTab extends HookConsumerWidget {
  const RecipeIngredientsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));
    final newIngredientMode = ref
        .watch(recipeScreenNotifierProvider.select((n) => n.newIngredientMode));
    final recipeIngredients = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.ingredients));

    final servingsMultiplierFactor = ref.watch(
        recipeScreenNotifierProvider.select((n) => n.servingsMultiplierFactor));

    Widget buildNewIngredientTile() {
      return _RecipeIngredientListTileWrapper(
        key: ValueKey('new'),
        editEnabled: editEnabled,
        servingsMultiplierFactor: servingsMultiplierFactor,
        onFocusChanged: (hasFocus) {
          if (!hasFocus) {
            notifier.newIngredientMode = false;
          }
        },
        onChanged: (value) {
          notifier.newIngredientMode = false;
          if (value is Ingredient) {
            notifier.addRecipeIngredientFromIngredient(value);
          } else if (value is String) {
            notifier.addRecipeIngredientFromString(value);
          } else if (value is RecipeIngredient) {}
        },
      );
    }

    List<Widget> buildRecipeIngredientTiles() {
      return recipeIngredients.mapIndexed((idx, recipeIng) {
        return _RecipeIngredientListTileWrapper(
          key: ValueKey(idx),
          servingsMultiplierFactor: servingsMultiplierFactor,
          recipeIngredient: recipeIng,
          editEnabled: editEnabled,
          onFocusChanged: (hasFocus) {
            if (!hasFocus) {
              notifier.newIngredientMode = false;
            }
          },
          onChanged: (value) {
            notifier.newIngredientMode = false;

            if (value is RecipeIngredient) {
              notifier.updateRecipeIngredientAtIndex(idx, value);
            } else if (value is Ingredient) {
              notifier.updateRecipeIngredientFromIngredientAtIndex(idx, value);
            } else if (value is String) {
              notifier.updateRecipeIngredientFromStringAtIndex(idx, value);
            }
          },
          onDelete: () {
            notifier.deleteRecipeIngredientByIndex(idx);
          },
        );
      }).toList();
    }

    return Column(
      children: [
        if (!newIngredientMode && recipeIngredients.isEmpty)
          EmptyPagePlaceholder(
            icon: Icons.add_circle_outline_sharp,
            text: 'No ingredients yet',
            sizeRate: 0.8,
            margin: const EdgeInsets.only(top: 100),
          ),
        if (newIngredientMode) buildNewIngredientTile(),
        if (recipeIngredients.isNotEmpty) ...buildRecipeIngredientTiles(),
      ],
    );
  }
}

class _RecipeIngredientListTileWrapper extends HookConsumerWidget {
  final RecipeIngredient? recipeIngredient;
  final bool editEnabled;
  final bool autofocus;
  final double? servingsMultiplierFactor;
  final Function(dynamic)? onChanged;
  final Function(bool)? onFocusChanged;
  final Function()? onDelete;

  _RecipeIngredientListTileWrapper(
      {this.recipeIngredient,
      this.servingsMultiplierFactor,
      this.editEnabled = false,
      this.autofocus = false,
      this.onChanged,
      this.onFocusChanged,
      this.onDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recipeIngredient != null) {
      return _RecipeIngredientListTile(
        key: ValueKey(recipeIngredient!.ingredientName),
        recipeIngredient: recipeIngredient,
        editEnabled: editEnabled,
        servingsMultiplierFactor: servingsMultiplierFactor,
        onChanged: onChanged,
        onFocusChanged: onFocusChanged,
        onDelete: onDelete,
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
  final double? servingsMultiplierFactor;
  final bool loading;
  final bool editEnabled;
  final bool autofocus;
  final Function(dynamic)? onChanged;
  final Function()? onDelete;
  final Function(bool)? onFocusChanged;

  const _RecipeIngredientListTile({
    Key? key,
    this.recipeIngredient,
    this.servingsMultiplierFactor,
    this.loading = false,
    this.editEnabled = false,
    this.autofocus = false,
    this.onChanged,
    this.onDelete,
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
        clipBehavior: Clip.hardEdge,
        child: loading
            ? DefaultShimmer()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _IngredientSuggestionTextField(
                  recipeIngredient: recipeIngredient,
                  enabled: editEnabled,
                  autofocus: autofocus,
                  onSubmitted: onChanged,
                  onFocusChanged: onFocusChanged,
                  onDelete: onDelete,
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

class _IngredientSuggestionTextField extends HookConsumerWidget {
  final RecipeIngredient? recipeIngredient;

  final bool enabled;
  final bool autofocus;

  final ScrollController? scrollController;

  final int suggestAfter;

  final void Function(dynamic)? onSubmitted;
  final void Function()? onDelete;
  final void Function(bool)? onFocusChanged;

  const _IngredientSuggestionTextField({
    Key? key,
    this.recipeIngredient,
    this.enabled = true,
    this.autofocus = false,
    this.suggestAfter = 1,
    this.scrollController,
    this.onSubmitted,
    this.onDelete,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFocus = useState(false);
    final hasText = useState(false);

    final ingredientsStream = ref.read(ingredientsRepositoryProvider).stream();

    return RepositoryStreamBuilder<List<Ingredient>>(
      stream: ingredientsStream,
      builder: (context, model) {
        return Autocomplete<Ingredient>(
          initialValue:
              TextEditingValue(text: recipeIngredient?.ingredientName ?? ''),
          optionsMaxHeight: 100,
          optionsBuilder: (textEditingValue) async {
            if (textEditingValue.text.length < suggestAfter ||
                !enabled ||
                textEditingValue.text == recipeIngredient?.ingredientName)
              return const <Ingredient>[];

            return model.where((i) => i.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (option) => option.name,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            focusNode.addListener(() {
              hasFocus.value = focusNode.hasPrimaryFocus;

              if (!focusNode.hasPrimaryFocus) {
                textEditingController.text =
                    recipeIngredient?.ingredientName ?? '';
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
                    suffixIcon: _buildSuffixIcon(
                      ref,
                      editEnabled: enabled,
                      hasFocus: hasFocus.value,
                      hasText: hasText.value,
                      controller: textEditingController,
                    )),
                onSubmitted: (text) => _submit(ref, text));
          },
        );
      },
    );
  }

  Widget? _buildSuffixIcon(
    WidgetRef ref, {
    required bool editEnabled,
    required bool hasFocus,
    required bool hasText,
    required TextEditingController controller,
  }) {
    if (editEnabled) {
      if (hasFocus && hasText) {
        return IconButton(
          icon: Icon(Icons.done),
          onPressed: () => _submit(ref, controller.text),
        );
      } else {
        return IconButton(icon: Icon(Icons.close), onPressed: onDelete);
      }
    }

    /* if (editEnabled) {
      if (hasFocus) {
        return IconButton(
            icon: Icon(Icons.done),
            onPressed: () => _onSubmit(controller: controller));
      } else {
        return IconButton(icon: Icon(Icons.close), onPressed: onDelete);
      }
    } */
  }

  void _submit(WidgetRef ref, String text) async {
    if (onSubmitted != null) {
      final ingredients =
          await ref.read(ingredientsRepositoryProvider).loadAll(remote: false);
      final ing = ingredients.firstWhereOrNull((i) => i.name.trim() == text);

      onSubmitted!(ing ?? text.trim());
    }
  }
}
