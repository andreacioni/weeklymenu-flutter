import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/menu.dart';
import 'package:model/recipe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/date.dart';
import 'package:common/log.dart';
import 'package:common/extensions.dart';
import 'package:shimmer/shimmer.dart';

import '../menu_page/screen.dart';

part 'import_from_menu_screen.g.dart';

final _screenNotifierProvider = StateNotifierProvider.autoDispose<
    _ImportFromMenuScreenStateNotifier, _ImportFromMenuScreenState>((ref) {
  List<DailyMenu> loadDailyMenus() {
    final now = Date.now();
    final startDate =
        now.subtract(Duration(days: ImportFromMenuScreen.START_DAY_OFFSET));

    return List.generate(ImportFromMenuScreen.LOAD_MENU_DAYS_LIMIT, (index) {
      final dailyMenu =
          ref.watch(dailyMenuProvider(startDate.add(Duration(days: index))));

      return dailyMenu;
    });
  }

  return _ImportFromMenuScreenStateNotifier(
      _ImportFromMenuScreenState(dailyMenuList: loadDailyMenus()));
});

@immutable
@CopyWith()
class _ImportFromMenuScreenState {
  final List<DailyMenu> dailyMenuList;
  final Map<DailyMenu, List<Recipe>> selectedRecipes;
  final Map<RecipeIngredient, bool> selectedIngredients;

  _ImportFromMenuScreenState(
      {this.dailyMenuList = const <DailyMenu>[],
      this.selectedRecipes = const <DailyMenu, List<Recipe>>{},
      this.selectedIngredients = const <RecipeIngredient, bool>{}});

  List<DailyMenu> get notEmptyDailyMenuList {
    return [...dailyMenuList]..removeWhere((d) => d.isEmpty);
  }

  List<Recipe> selectedRecipesForDailyMenu(DailyMenu dailyMenu) {
    return selectedRecipes[dailyMenu] ?? <Recipe>[];
  }
}

class _ImportFromMenuScreenStateNotifier
    extends StateNotifier<_ImportFromMenuScreenState> {
  _ImportFromMenuScreenStateNotifier(super.state);

  void selectRecipe(DailyMenu dailyMenu, Recipe recipe, bool selected) {
    final currentSelection = state.selectedRecipesForDailyMenu(dailyMenu);
    if (selected) {
      currentSelection.add(recipe);
    } else {
      currentSelection.remove(recipe);
    }
    final newSelection = {...state.selectedRecipes};
    newSelection[dailyMenu] = currentSelection;
    state = state.copyWith(
        selectedRecipes: newSelection,
        selectedIngredients: _computeSelectedRecipes(newSelection));
  }

  Map<RecipeIngredient, bool> _computeSelectedRecipes(
      Map<DailyMenu, List<Recipe>> selectedRecipes) {
    final ingredients = <RecipeIngredient>[];
    selectedRecipes.entries.forEach((r) {
      ingredients.addAll(r.value.expand((e) => e.ingredients));
    });
    return Map.fromIterable(ingredients, key: (e) => e, value: (_) => true);
  }

  void selectIngredient(RecipeIngredient recipeIngredient, bool value) {
    final newValue = {...state.selectedIngredients};
    newValue[recipeIngredient] = value;
    state = state.copyWith(selectedIngredients: newValue);
  }

  void resetSelectedIngredients() {
    state = state.copyWith(
        selectedIngredients: _computeSelectedRecipes(state.selectedRecipes));
  }
}

class ImportFromMenuScreen extends HookConsumerWidget {
  static const LOAD_MENU_DAYS_LIMIT = 10;
  static const START_DAY_OFFSET = 3;

  const ImportFromMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(_screenNotifierProvider);
    final notifier = ref.read(_screenNotifierProvider.notifier);
    final dailyMenuList = state.notEmptyDailyMenuList;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select recipes"),
      ),
      floatingActionButton: state.selectedIngredients.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => onFabPressed(context, notifier),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "+${state.selectedIngredients.length} ingredient/s",
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black54,
                  size: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Select the recipes in the daily menu to import the corresponding ingredients to the shopping list.",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: dailyMenuList.length,
                itemBuilder: (context, idx) =>
                    _DailyMenuWrapper(dailyMenuList[idx])),
          ),
        ],
      ),
    );
  }

  void onFabPressed(
      BuildContext context, _ImportFromMenuScreenStateNotifier notifier) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => _SelectIngredientScreen()));

    notifier.resetSelectedIngredients();
  }
}

class _DailyMenuWrapper extends HookConsumerWidget {
  static final DAILY_MENU_DATE_PARSER = DateFormat('EEE,dd');

  final DailyMenu dailyMenu;

  const _DailyMenuWrapper(this.dailyMenu, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recipeRepo = ref.read(recipeRepositoryProvider);
    final recipeIds = dailyMenu.recipeIds;
    final Iterable<Future<Recipe?>> recipeListFutures =
        recipeIds.map((id) async {
      try {
        final recipe = await recipeRepo.load(id);
        if (recipe != null) return recipe;
      } catch (e, st) {
        //we skip recipe that are not available
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load some recipes")));
        logError("failed to retrieve recipe: ${id}", e, st);
      }
      return null;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DAILY_MENU_DATE_PARSER.format(dailyMenu.day.toDateTime),
            style: theme.textTheme.titleLarge,
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder(
          future: Future.wait(recipeListFutures),
          builder: (context, snapshot) {
            final widgets = !snapshot.hasData
                ? buildShimmer(recipeListFutures.length)
                : snapshot.data!.mapNullable((r) => buildRecipeWidget(r, ref));

            return Container(
              constraints: BoxConstraints(maxHeight: 70),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widgets.length,
                  itemBuilder: ((context, index) {
                    return widgets[index];
                  })),
            );
          },
        ),
      ],
    );
  }

  List<Widget> buildShimmer(int num) {
    return List.generate(
        num,
        (_) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                height: 70,
                width: 200,
                margin: EdgeInsets.only(right: 10),
              ),
            ));
  }

  Widget? buildRecipeWidget(Recipe? recipe, WidgetRef ref) {
    final selectedRecipes = ref
        .read(_screenNotifierProvider)
        .selectedRecipesForDailyMenu(dailyMenu);
    final notifier = ref.read(_screenNotifierProvider.notifier);
    if (recipe != null)
      return _SelectableRecipeCard(
        recipe,
        selected: selectedRecipes.contains(recipe),
        onSelected: (v) {
          notifier.selectRecipe(dailyMenu, recipe, v);
        },
      );
    return null;
  }
}

class _SelectableRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const _SelectableRecipeCard(this.recipe,
      {super.key, this.onSelected, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(10);
    return GestureDetector(
      onTap: () => onSelected?.call(!selected),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
              color: selected
                  ? theme.primaryColor.withOpacity(0.8)
                  : Colors.transparent),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? theme.primaryColor.withOpacity(0.5) : null,
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name),
                  SizedBox(height: 10),
                  Text(
                    recipe.ingredients.length.toString() + " ingredient/s",
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
              SizedBox(height: 20),
              Checkbox.adaptive(
                  value: selected, onChanged: (v) => onSelected?.call(v!)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectIngredientScreen extends HookConsumerWidget {
  const _SelectIngredientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(_screenNotifierProvider.notifier);
    final ingredientsSelection =
        ref.watch(_screenNotifierProvider).selectedIngredients;
    final ingredients = ingredientsSelection.entries.map((e) => e.key).toList();

    final selectedItems = ingredientsSelection.entries.where(
      (e) => e.value,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Import ingredients"),
      ),
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Icon(Icons.check),
                  Text(
                    selectedItems.length.toString(),
                    style: theme.textTheme.labelSmall,
                  )
                ],
              ),
              onPressed: () {},
            )
          : null,
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return _IngredientCheckboxTile(
            ingredients[index],
            selected: ingredientsSelection[ingredients[index]] ?? false,
            onSelected: (v) {
              notifier.selectIngredient(ingredients[index], v);
            },
          );
        },
      ),
    );
  }
}

class _IngredientCheckboxTile extends StatelessWidget {
  final RecipeIngredient ingredient;
  final bool selected;
  final ValueChanged? onSelected;
  const _IngredientCheckboxTile(this.ingredient,
      {super.key, this.selected = false, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(ingredient.quantity.toString()),
      title: Text(ingredient.ingredientName),
      trailing: Checkbox(
        value: selected,
        onChanged: (v) {
          onSelected?.call(v);
        },
      ),
    );
  }
}
