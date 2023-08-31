import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:data/flutter_data/shopping_list.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model/menu.dart';
import 'package:model/recipe.dart';
import 'package:model/shopping_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';
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
  final Map<DailyMenu, Set<Recipe>> selectedRecipes;
  final Map<ShoppingListItem, bool> shoppingListItemSelection;

  _ImportFromMenuScreenState({
    this.dailyMenuList = const <DailyMenu>[],
    this.selectedRecipes = const <DailyMenu, Set<Recipe>>{},
    this.shoppingListItemSelection = const <ShoppingListItem, bool>{},
  });

  List<DailyMenu> get notEmptyDailyMenuList {
    return [...dailyMenuList]..removeWhere((d) => d.isEmpty);
  }

  Set<Recipe> selectedRecipesForDailyMenu(DailyMenu dailyMenu) {
    return selectedRecipes[dailyMenu] ?? <Recipe>{};
  }

  List<ShoppingListItem> get selectedItems {
    return ({...shoppingListItemSelection}..removeWhere((_, item) => !item))
        .keys
        .toList();
  }

  List<ShoppingListItem> get allItems {
    return shoppingListItemSelection.keys.toList();
  }
}

class _ImportFromMenuScreenStateNotifier
    extends StateNotifier<_ImportFromMenuScreenState> {
  final ShoppingListItemRepository shoppingListItemRepository;
  final String shoppingListId;

  _ImportFromMenuScreenStateNotifier(
      super.state, this.shoppingListItemRepository, this.shoppingListId);

  void selectRecipe(DailyMenu dailyMenu, Recipe recipe, bool selected) {
    final currentRecipeSelection = state.selectedRecipesForDailyMenu(dailyMenu);
    if (selected) {
      currentRecipeSelection.add(recipe);
    } else {
      currentRecipeSelection.remove(recipe);
    }
    final newSelection = {...state.selectedRecipes};
    newSelection[dailyMenu] = currentRecipeSelection;

    final items = _computeItemsForSelectedRecipes(newSelection)
        .fold(<ShoppingListItem, bool>{}, (previousValue, element) {
      //If a recipe is duplicated in more menus we need to merge
      //multiple shopping list items into one. Quantity can be merged only if
      //unit of measure is the same for each item.
      if (previousValue.containsKey(element)) {
        final checked = previousValue[element] ?? false;
        final oldElement = previousValue.keys
            .firstWhereOrNull((e) => e.itemName == element.itemName);
        previousValue.remove(element);

        final ShoppingListItem newElement;
        if (element.unitOfMeasure != oldElement?.unitOfMeasure) {
          newElement = element.copyWith(quantity: null, unitOfMeasure: null);
        } else {
          newElement = element.copyWith(
              quantity: (element.quantity ?? 0) + (oldElement?.quantity ?? 0));
        }

        previousValue[newElement] = checked;
      }

      previousValue[element] = true;

      return previousValue;
    });
    state = state.copyWith(
      shoppingListItemSelection: items,
      selectedRecipes: newSelection,
    );
  }

  List<ShoppingListItem> _computeItemsForSelectedRecipes(
      Map<DailyMenu, Set<Recipe>> recipeSelection) {
    return recipeSelection.values
        .map(List<Recipe>.from)
        .expand((recipes) => recipes)
        .map((recipe) => recipe.ingredients)
        .expand((ingredients) => ingredients)
        .map(ShoppingListItem.fromRecipeIngredient)
        .toList();
  }

  void selectIngredient(ShoppingListItem recipeIngredient, bool value) {
    final newState = {...state.shoppingListItemSelection};

    newState[recipeIngredient] = value;

    state = state.copyWith(shoppingListItemSelection: newState);
  }

  void selectAll() {
    final selection = state.allItems.map((i) => MapEntry(i, true));

    state =
        state.copyWith(shoppingListItemSelection: Map.fromEntries(selection));
  }

  void deselectAll() {
    final selection = state.allItems.map((i) => MapEntry(i, false));

    state =
        state.copyWith(shoppingListItemSelection: Map.fromEntries(selection));
  }

  void updateItem(ShoppingListItem newItem) {
    final selection = state.shoppingListItemSelection[newItem];
    if (selection != null) {
      final newState = state.shoppingListItemSelection..remove(newItem);
      newState[newItem] = selection;
      state = state.copyWith(shoppingListItemSelection: newState);
    } else {
      logWarn("item not found");
    }
  }

  void resetSelectedIngredients() {
    final items = _computeItemsForSelectedRecipes(state.selectedRecipes)
        .map((i) => MapEntry(i, true));
    state = state.copyWith(shoppingListItemSelection: Map.fromEntries(items));
  }

  void updateShoppingListWithSelectedIngredients() {
    Object? lastError;

    for (final s in state.selectedItems) {
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
    final selectedItems = ref
        .watch(_screenNotifierProvider.select((state) => state.selectedItems));
    final dailyMenuList = ref.watch(
        _screenNotifierProvider.select((state) => state.notEmptyDailyMenuList));
    ;

    final notifier = ref.read(_screenNotifierProvider.notifier);

    return _ScaffoldWithSuggestionBox(
      suggestion:
          "Select the recipes in the daily menu to import the corresponding ingredients to the shopping list.",
      icon: Icons.shopping_bag_outlined,
      appBar: AppBar(
        title: Text("Select recipes"),
      ),
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => onFabPressed(context, notifier),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "+${selectedItems.length} ingredient/s",
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
    if (recipe != null) {
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
    }

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
    final selectedItems = ref
        .watch(_screenNotifierProvider.select((state) => state.selectedItems));
    final allItems = ref
        .watch(_screenNotifierProvider.select((state) => state.allItems))
      ..sort((a, b) => a.itemName.compareTo(b.itemName));

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
                        notifier.updateItem(item);
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
