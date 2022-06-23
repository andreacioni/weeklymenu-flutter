import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:objectid/objectid.dart';
import 'package:weekly_menu_app/globals/hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../globals/utils.dart';
import '../../main.data.dart';
import '../flutter_data_state_builder.dart';
import '../../models/enums/meal.dart';
import '../../models/recipe.dart';
import '../../globals/constants.dart' as constants;
import '../../models/menu.dart';
import '../recipe_view/screen.dart';
import 'add_recipe_dialog.dart';
import 'screen.dart';

final MENU_CARD_ROUNDED_RECT_BORDER = BorderRadius.circular(10);
const SPACE_BETWEEN_ICON_AND_CARD = 15.0;

final _dragOriginDailyMenuNotifierProvider =
    StateProvider<DailyMenuNotifier?>((_) => null);

class DailyMenuSection extends HookConsumerWidget {
  static final _dialogDateParser = DateFormat('EEEE, dd');
  static final _appBarDateParser = DateFormat('EEE,dd');
  static final _appBarMonthParser = DateFormat('MMM');

  final DailyMenuNotifier dailyMenuNotifier;
  final bool isDragOverWidget;
  final void Function()? onTap;

  DailyMenuSection(
    this.dailyMenuNotifier, {
    this.onTap,
    this.isDragOverWidget = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = const EdgeInsets.fromLTRB(10, 5, 0, 0);

    final primaryColor = dailyMenuNotifier.dailyMenu.isPast
        ? constants.pastColor
        : (dailyMenuNotifier.dailyMenu.isToday
            ? constants.todayColor
            : Colors.amber.shade200);

    final displayEnterNewRecipeCard = useState(false);

    final focusNode = useFocusNode();

    Widget buildMenuContainer(Meal meal, Menu? menu,
        {bool displayPlaceholder = false}) {
      return MenuContainer(
        meal,
        key: ValueKey('$meal'),
        menu: menu,
        dailyMenuNotifier: dailyMenuNotifier,
        displayRecipePlaceholder: displayPlaceholder,
      );
    }

    Future<void> addRecipeToMeal(Meal meal, Recipe recipe) async {
      if (dailyMenuNotifier.dailyMenu.getMenuByMeal(meal) == null) {
        final menu = await ref.menus.save(Menu(
          date: dailyMenuNotifier.dailyMenu.day,
          recipes: [recipe.id],
          meal: meal,
        ));
        await dailyMenuNotifier.addMenu(menu);
      } else {
        await dailyMenuNotifier.addRecipeToMeal(meal, recipe);
      }
    }

    Future<void> createNewRecipeByName(Meal meal, String recipeName) async {
      if (recipeName.trim().isNotEmpty) {
        Recipe recipe = await ref.recipes
            .save(Recipe(id: ObjectId().hexString, name: recipeName));
        await addRecipeToMeal(meal, recipe);
      } else {
        print("can't create a recipe with empty name");
      }
    }

    Future<void> openAddRecipeToDailyMenuDialog() async {
      final newMealRecipe = await showDialog(
          context: context,
          builder: (context) => RecipeSelectionDialog(
              title: _dialogDateParser
                  .format(dailyMenuNotifier.dailyMenu.day.toDateTime)));

      print('selected $newMealRecipe');

      if (newMealRecipe != null && newMealRecipe['meal'] != null) {
        if (newMealRecipe['recipeTitle'] != null) {
          createNewRecipeByName(newMealRecipe['meal'] as Meal,
              newMealRecipe['recipeTitle'] as String);
        } else if (newMealRecipe['recipe'] != null) {
          addRecipeToMeal(
              newMealRecipe['meal'] as Meal, newMealRecipe['recipe'] as Recipe);
        }
      }
    }

    Widget buildEnterNewRecipeCard() {
      return Row(
        key: ValueKey('new-recipe-card'),
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton(
            initialValue: Meal.Breakfast,
            itemBuilder: (context) => Meal.values
                .map((m) => PopupMenuItem<Meal>(value: m, child: Icon(m.icon)))
                .toList(),
          ),
          const SizedBox(width: SPACE_BETWEEN_ICON_AND_CARD),
          Expanded(
            child: _CardPrototype(
              child: _RecipeSuggestionTextField(
                focusNode: focusNode,
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    displayEnterNewRecipeCard.value = false;
                  }
                },
                onCancel: () {
                  displayEnterNewRecipeCard.value = false;
                },
                hintText: 'Delicious pizza',
              ),
            ),
          ),
        ],
      );
    }

    Widget buildCardTitle() {
      return Row(
        key: ValueKey('title'),
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            softWrap: false,
            textAlign: TextAlign.start,
            text: TextSpan(
              text: dailyMenuNotifier.dailyMenu.day.format(_appBarDateParser) +
                  ' ',
              style: GoogleFonts.b612Mono().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFeatures: [
                  FontFeature.tabularFigures(),
                ],
              ),
              children: <TextSpan>[
                TextSpan(
                  text: dailyMenuNotifier.dailyMenu.day
                      .format(_appBarMonthParser),
                  style: GoogleFonts.b612Mono().copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w200,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: primaryColor.withOpacity(0.8)),
            ),
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black87,
            ),
            onPressed: () {
              displayEnterNewRecipeCard.value = true;
              focusNode.requestFocus();
            },
            splashRadius: 15.0,
          ),
        ],
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: primaryColor),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            buildCardTitle(),
            if (displayEnterNewRecipeCard.value) buildEnterNewRecipeCard(),
            ...Meal.values.map((m) {
              final menu = dailyMenuNotifier.dailyMenu.getMenuByMeal(m);

              return buildMenuContainer(m, menu,
                  displayPlaceholder: isDragOverWidget);
            }).toList()
          ],
        ),
      ),
    );
  }
}

class MealRecipeCardContainer extends StatelessWidget {
  final String recipeId;
  final Meal meal;

  final DailyMenuNotifier dailyMenuNotifier;
  final bool displayLeadingMealIcon;

  const MealRecipeCardContainer(this.meal, this.recipeId,
      {Key? key,
      required this.dailyMenuNotifier,
      this.displayLeadingMealIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          meal.icon,
          color: displayLeadingMealIcon ? Colors.black : Colors.transparent,
        ),
        SizedBox(width: 15),
        Expanded(
            child: MenuRecipeWrapper(
          recipeId,
          meal: meal,
          dailyMenuNotifier: dailyMenuNotifier,
        ))
      ],
    );
  }
}

class MenuContainer extends HookConsumerWidget {
  final Meal meal;
  final Menu? menu;
  final DailyMenuNotifier dailyMenuNotifier;
  final bool displayRecipePlaceholder;

  MenuContainer(
    this.meal, {
    Key? key,
    this.menu,
    required this.dailyMenuNotifier,
    this.displayRecipePlaceholder = false,
  })  : assert(menu == null || meal == menu.meal),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeIds = menu?.recipes ?? [];

    final isDragging = ref.read(isDraggingMenuStateProvider);

    Widget buildDragTargetPlaceholder({bool displayLeadingMealIcon = false}) {
      return MenuRecipeDragTarget(
        menu: menu,
        meal: meal,
        dailyMenuNotifier: dailyMenuNotifier,
        child: Row(
          children: [
            Icon(meal.icon,
                color:
                    displayLeadingMealIcon ? Colors.black : Colors.transparent),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.grey,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      spreadRadius: -5.0,
                      blurRadius: 9.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      key: key,
      children: [
        ...recipeIds
            .map((id) => MealRecipeCardContainer(meal, id,
                dailyMenuNotifier: dailyMenuNotifier,
                displayLeadingMealIcon: id == recipeIds[0]))
            .toList(),
        isDragging && displayRecipePlaceholder
            ? buildDragTargetPlaceholder(displayLeadingMealIcon: menu == null)
            : Container(),
        if (recipeIds.isNotEmpty) SizedBox(height: 20),
      ],
    );
  }
}

class MenuRecipeDragTarget extends HookConsumerWidget {
  final Widget child;
  final DailyMenuNotifier dailyMenuNotifier;
  final Menu? menu;
  final Meal? meal;

  final void Function()? onEnter;
  final void Function()? onLeave;

  MenuRecipeDragTarget({
    required this.child,
    required this.dailyMenuNotifier,
    this.menu,
    this.meal,
    this.onEnter,
    this.onLeave,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyMenu = useStateNotifier(dailyMenuNotifier);

    final meal = menu?.meal ?? this.meal!;

    final originalDailyMenuNotifier =
        ref.watch(_dragOriginDailyMenuNotifierProvider);

    return DragTarget<MealRecipe>(
        hitTestBehavior: HitTestBehavior.deferToChild,
        onWillAccept: (mealRecipe) {
          final menu = dailyMenu.getMenuByMeal(meal);
          final ret =
              (menu?.recipes.contains(mealRecipe?.recipe.id) ?? false) == false;
          print('on will accept: $ret');
          onEnter?.call();
          return ret;
        },
        onLeave: (_) {
          onLeave?.call();
        },
        onAccept: (mealRecipe) {
          print('onAccept - $mealRecipe');

          final recipeIds = [mealRecipe.recipe.id];

          final destinationMenu = dailyMenu.getMenuByMeal(meal);
          if (destinationMenu == null) {
            final menu = Menu(
                id: ObjectId().hexString,
                date: dailyMenu.day,
                meal: meal,
                recipes: recipeIds);
            dailyMenuNotifier.addMenu(menu);
          } else {
            final newMenu = destinationMenu
                .copyWith(recipes: [...destinationMenu.recipes, ...recipeIds]);
            dailyMenuNotifier.updateMenu(newMenu);
          }

          originalDailyMenuNotifier?.removeRecipesFromMeal(
              mealRecipe.meal, recipeIds);

          ref.read(_dragOriginDailyMenuNotifierProvider.notifier).state = null;
        },
        builder: (_, __, ___) => child);
  }
}

class MenuRecipeWrapper extends HookConsumerWidget {
  final String recipeId;

  final Meal meal;
  final DailyMenuNotifier dailyMenuNotifier;

  MenuRecipeWrapper(this.recipeId,
      {required this.meal, required this.dailyMenuNotifier, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<Recipe>(
        state: ref.recipes.watchOne(recipeId),
        builder: (context, recipe) {
          return MenuRecipeCard(
            recipe,
            meal: meal,
            dailyMenuNotifier: dailyMenuNotifier,
          );
        });
  }
}

class MenuRecipeCard extends HookConsumerWidget {
  final Recipe recipe;

  final Meal meal;
  final DailyMenuNotifier dailyMenuNotifier;

  final bool? disabled;

  MenuRecipeCard(
    this.recipe, {
    Key? key,
    required this.dailyMenuNotifier,
    required this.meal,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    void openRecipeView(Recipe recipe) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeView(recipe),
        ),
      );
    }

    Widget buildDraggableFeedback(MediaQueryData mediaQuery) {
      return Container(
        decoration: BoxDecoration(borderRadius: MENU_CARD_ROUNDED_RECT_BORDER),
        width: mediaQuery.size.width,
        child: MenuRecipeCard(recipe,
            meal: meal, dailyMenuNotifier: dailyMenuNotifier),
      );
    }

    Widget buildChildWhenDragging(MediaQueryData mediaQuery) {
      return MenuRecipeCard(
        recipe,
        meal: meal,
        dailyMenuNotifier: dailyMenuNotifier,
        disabled: true,
      );
    }

    Widget buildInfoAndDragSection(ThemeData theme, MediaQueryData mediaQuery) {
      return Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.drag_indicator,
                color: Colors.black38,
                size: theme.iconTheme.size! - 1,
              ),
            ],
          ),
        ),
      );
    }

    Widget buildImageAndTitle(Recipe recipe, ThemeData theme) {
      /**
           * GestureDetector & AbsorbPointer below need to stay there to 
           * intercept and inhibits the drag gesture. Could be improved.
           */
      return Flexible(
        flex: 5,
        child: GestureDetector(
          onLongPress: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (recipe.imgUrl != null)
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: MENU_CARD_ROUNDED_RECT_BORDER.copyWith(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Image(
                      height: 50,
                      width: 90,
                      image: CachedNetworkImageProvider(recipe.imgUrl!),
                      errorBuilder: (_, __, ___) => Container(),
                      fit: BoxFit.cover),
                ),
              Expanded(
                child: AbsorbPointer(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: AutoSizeText(
                      recipe.name,
                      maxLines: 1,
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LongPressDraggable<MealRecipe>(
      //delay: Duration(milliseconds: 200),
      /*  dragAnchorStrategy: (draggable, context, position) {
        final offset = childDragAnchorStrategy(draggable, context, position);
        return Offset(offset.dx + 45, offset.dy);
      }, */
      data: MealRecipe(meal, recipe),
      feedback: buildDraggableFeedback(mediaQuery),
      childWhenDragging: buildChildWhenDragging(mediaQuery),
      onDragStarted: () {
        print('drag started');
        ref.read(isDraggingMenuStateProvider.state).state = true;
        ref.read(_dragOriginDailyMenuNotifierProvider.notifier).state =
            dailyMenuNotifier;
      },
      onDragEnd: (_) {
        print('drag end');
        ref.read(isDraggingMenuStateProvider.state).state = false;
      },
      axis: Axis.vertical,
      //affinity: Axis.horizontal,

      child: _CardPrototype(
        color: disabled == true
            ? Color.fromARGB(255, 202, 199, 199)
            : Colors.white,
        child: InkWell(
          borderRadius: MENU_CARD_ROUNDED_RECT_BORDER,
          highlightColor: theme.primaryColor.withOpacity(0.4),
          splashColor: theme.primaryColor.withOpacity(0.6),
          onTap: () => openRecipeView(recipe),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildImageAndTitle(recipe, theme),
              buildInfoAndDragSection(theme, mediaQuery)
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeSuggestionTextField extends HookConsumerWidget {
  final dynamic value;
  final String? hintText;
  final bool showSuggestions;
  final FocusNode? focusNode;
  final void Function(Recipe)? onRecipeSelected;
  final void Function(String)? onTextChanged;
  final Function()? onTap;
  final Function(bool)? onFocusChange;
  final Function()? onCancel;
  final bool enabled;

  _RecipeSuggestionTextField({
    this.value,
    this.onRecipeSelected,
    this.onTextChanged,
    this.showSuggestions = true,
    this.onTap,
    this.hintText,
    this.enabled = true,
    this.onCancel,
    this.onFocusChange,
    this.focusNode,
  }) : assert(value == null || value is String || value is Recipe);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (focusNode != null) {
      _setupFocusListener();
    }

    final textEditingController = useTextEditingController();

    if (value != null) {
      if (value is Recipe)
        textEditingController.text = value!.name;
      else if (value is String) textEditingController.text = value;

      textEditingController.selection =
          TextSelection.collapsed(offset: textEditingController.text.length);
    }

    final recipeRepository = ref.read(recipesRepositoryProvider);

    return TypeAheadField<Recipe>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: textEditingController,
        enabled: enabled,
        focusNode: focusNode,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(6.0),
            hintText: hintText,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            isDense: true,
            suffixIconConstraints: BoxConstraints(maxHeight: 35),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
                size: 35 / 2,
              ),
              onPressed: onCancel,
            )),
        maxLines: 1,
        onChanged: onTextChanged,
      ),
      itemBuilder: _itemBuilder,
      onSuggestionSelected: _onSuggestionSelected,
      suggestionsCallback: (pattern) =>
          _suggestionsCallback(pattern, recipeRepository),
      hideOnEmpty: true,
      autoFlipDirection: true,
      hideOnLoading: true,
      hideSuggestionsOnKeyboardHide: false,
      minCharsForSuggestions: 1,
    );
  }

  void _setupFocusListener() {
    useEffect((() {
      void focusListener() {
        if (!focusNode!.hasFocus) {
          onFocusChange?.call(focusNode!.hasFocus);
        }
      }

      focusNode!.addListener(focusListener);

      return () => focusNode!..removeListener(focusListener);
    }), const []);
  }

  void _onSuggestionSelected(Recipe item) {
    if (onRecipeSelected != null) {
      onRecipeSelected!(item);
    }
  }

  Future<List<Recipe>> _suggestionsCallback(
      String pattern, Repository<Recipe> recipesRepository) async {
    final availableRecipes =
        await recipesRepository.findAll(remote: false) ?? [];
    final List<Recipe> suggestions = [];

    suggestions.addAll(availableRecipes
        .where((ing) => stringContains(ing.name, pattern))
        .toList());

    return suggestions;
  }

  Widget _itemBuilder(BuildContext buildContext, Recipe recipe) {
    return ListTile(
      title: Text(recipe.name),
      trailing: Icon(Icons.check_box),
    );
  }
}

class _CardPrototype extends StatelessWidget {
  final Widget child;
  final Color? color;

  const _CardPrototype({
    Key? key,
    required this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: color,
        shape:
            RoundedRectangleBorder(borderRadius: MENU_CARD_ROUNDED_RECT_BORDER),
        elevation: 3,
        child: child);
  }
}
