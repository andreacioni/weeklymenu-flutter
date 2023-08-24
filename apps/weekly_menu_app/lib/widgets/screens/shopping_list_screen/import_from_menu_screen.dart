import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/menu.dart';
import 'package:model/recipe.dart';
import 'package:model/shopping_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/date.dart';
import 'package:common/log.dart';
import 'package:common/extensions.dart';
import 'package:common/constants.dart';

import 'package:shimmer/shimmer.dart';
import 'package:weekly_menu_app/providers/shopping_list.dart';
import 'package:weekly_menu_app/widgets/screens/shopping_list_screen/shopping_list_tile.dart';

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
    _ImportFromMenuScreenState(dailyMenuList: loadDailyMenus()),
    ref.read(shoppingListItemRepositoryProvider),
    ref.read(shoppingListProvider)!.idx,
  );
});

@immutable
@CopyWith()
class _ImportFromMenuScreenState {
  final List<DailyMenu> dailyMenuList;
  final Map<DailyMenu, List<Recipe>> selectedRecipes;
  final List<ShoppingListItem> selectedIngredients;

  _ImportFromMenuScreenState(
      {this.dailyMenuList = const <DailyMenu>[],
      this.selectedRecipes = const <DailyMenu, List<Recipe>>{},
      this.selectedIngredients = const <ShoppingListItem>[]});

  List<DailyMenu> get notEmptyDailyMenuList {
    return [...dailyMenuList]..removeWhere((d) => d.isEmpty);
  }

  List<Recipe> selectedRecipesForDailyMenu(DailyMenu dailyMenu) {
    return selectedRecipes[dailyMenu] ?? <Recipe>[];
  }

  List<ShoppingListItem> get allRecipeIngredients {
    return selectedRecipes.entries
        .map((e) => e.value)
        .expand((e) => e)
        .expand((e) => e.ingredients)
        .map(ShoppingListItem.fromRecipeIngredient)
        .toList();
  }
}

class _ImportFromMenuScreenStateNotifier
    extends StateNotifier<_ImportFromMenuScreenState> {
  final ShoppingListItemRepository shoppingListItemRepository;
  final String shoppingListId;

  _ImportFromMenuScreenStateNotifier(
      super.state, this.shoppingListItemRepository, this.shoppingListId);

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

  List<ShoppingListItem> _computeSelectedRecipes(
      Map<DailyMenu, List<Recipe>> selectedRecipes) {
    final ingredients = <ShoppingListItem>[];
    selectedRecipes.entries.forEach((r) {
      ingredients.addAll(r.value
          .expand((e) => e.ingredients)
          .map(ShoppingListItem.fromRecipeIngredient));
    });
    return ingredients;
  }

  void selectIngredient(ShoppingListItem recipeIngredient, bool value) {
    final newState = [...state.selectedIngredients];
    if (value) {
      newState.add(recipeIngredient);
    } else {
      newState.remove(recipeIngredient);
    }

    state = state.copyWith(selectedIngredients: newState);
  }

  void selectAll() {
    final newState = [...state.allRecipeIngredients];

    state = state.copyWith(selectedIngredients: newState);
  }

  void deselectAll() {
    final newState = <ShoppingListItem>[];

    state = state.copyWith(selectedIngredients: newState);
  }

  void updateIngredient(ShoppingListItem newItem) {
    final newState = [...state.allRecipeIngredients]
      ..removeWhere((i) => i.itemName == newItem.itemName);

    newState.add(newItem);

    state = state.copyWith();
  }

  void resetSelectedIngredients() {
    state = state.copyWith(
        selectedIngredients: _computeSelectedRecipes(state.selectedRecipes));
  }

  void updateShoppingListWithSelectedIngredients() {
    Object? lastError;

    for (final s in state.selectedIngredients) {
      try {
        // update params is always true because on PUT the server search
        // if there is an ingredient already present
        shoppingListItemRepository.save(s, params: {
          UPDATE_PARAM: true,
          SHOPPING_LIST_ID_PARAM: shoppingListId
        });
      } catch (e, st) {
        logError("failed to save '${s.itemName}' in shopping list", e, st);
        lastError = e;
      }
    }

    if (lastError != null) {
      throw lastError;
    }
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
    return _ScaffoldWithSuggestionBox(
      suggestion:
          "Select the recipes in the daily menu to import the corresponding ingredients to the shopping list.",
      icon: Icons.shopping_bag_outlined,
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
      body: Expanded(
        child: ListView.builder(
            itemCount: dailyMenuList.length,
            itemBuilder: (context, idx) =>
                _DailyMenuWrapper(dailyMenuList[idx])),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to load some recipes"),
          behavior: SnackBarBehavior.floating,
        ));
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
                : snapshot.data!
                    .mapNullable((r) => buildRecipeWidget(context, r, ref));

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

  Widget? buildRecipeWidget(
      BuildContext context, Recipe? recipe, WidgetRef ref) {
    final selectedRecipes = ref
        .read(_screenNotifierProvider)
        .selectedRecipesForDailyMenu(dailyMenu);
    final notifier = ref.read(_screenNotifierProvider.notifier);
    if (recipe != null)
      return _SelectableRecipeCard(
        recipe,
        selected: selectedRecipes.contains(recipe),
        onSelected: (v) {
          if (recipe.ingredients.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("No ingredients in this recipe"),
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            notifier.selectRecipe(dailyMenu, recipe, v);
          }
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
              if (recipe.ingredients.isNotEmpty)
                Checkbox.adaptive(
                  value: selected,
                  onChanged: (v) => onSelected?.call(v!),
                )
              else
                SizedBox(
                  width: 50,
                )
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
    final selectedItems =
        ref.watch(_screenNotifierProvider).selectedIngredients;
    final allItems = ref.watch(_screenNotifierProvider).allRecipeIngredients;

    return _ScaffoldWithSuggestionBox(
      suggestion: "Check the ingredients you want to add to the shopping list",
      icon: Icons.check_box_outlined,
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
              onPressed: () => handleFabPressed(context, notifier),
            )
          : null,
      body: Expanded(
        child: Column(
          children: [
            ListTile(
                trailing: Checkbox(
                    value: getCheckboxOverall(selectedItems, allItems),
                    tristate: true,
                    onChanged: (v) {
                      if (v == true) {
                        notifier.selectAll();
                      } else if (v == null || v == false) {
                        notifier.deselectAll();
                      }
                    })),
            Divider(height: 0),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  return ShoppingListItemTile(
                    key: ValueKey("ShoppingListItemTile ${allItems[index]}"),
                    allItems[index],
                    checked: selectedItems.contains(allItems[index]),
                    editable: false,
                    onCheckChange: (v) {
                      notifier.selectIngredient(allItems[index], v!);
                    },
                    onSubmitted: (item) {
                      if (item is ShoppingListItem) {
                        notifier.updateIngredient(item);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool? getCheckboxOverall(
      List<ShoppingListItem> selectedItems, List<ShoppingListItem> allItems) {
    if (selectedItems.length == 0) return false;
    if (selectedItems.length == allItems.length)
      return true;
    else
      return null;
  }

  void handleFabPressed(
      BuildContext context, _ImportFromMenuScreenStateNotifier notifier) {
    //TODO improve with named route
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    try {
      notifier.updateShoppingListWithSelectedIngredients();
    } catch (e, st) {
      logError("failed to save shopping list", e, st);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to save one or more items"),
        showCloseIcon: true,
      ));
    }
  }
}

class _ScaffoldWithSuggestionBox extends StatelessWidget {
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? body;
  final PreferredSizeWidget? appBar;

  final String suggestion;
  final IconData icon;
  const _ScaffoldWithSuggestionBox({
    super.key,
    required this.suggestion,
    required this.icon,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Colors.black87,
                  size: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    suggestion,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          if (body != null) body!,
        ],
      ),
    );
  }
}
