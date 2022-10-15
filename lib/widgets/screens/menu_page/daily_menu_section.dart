import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:collection/collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider;
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../globals/constants.dart';
import '../../../globals/utils.dart';
import '../../../main.data.dart';
import '../../shared/flutter_data_state_builder.dart';
import '../../../models/enums/meal.dart';
import '../../../models/recipe.dart';
import '../../../globals/constants.dart' as constants;
import '../../../models/menu.dart';
import '../recipe_screen/screen.dart';
import 'screen.dart';

final MENU_CARD_ROUNDED_RECT_BORDER = BorderRadius.circular(10);
const SPACE_BETWEEN_ICON_AND_CARD = 15.0;
const _ICON_MARGIN = const EdgeInsets.all(5);
final _appBarDateParser = DateFormat('EEE,dd');
final _appBarMonthParser = DateFormat('MMM');

final _dragOriginDailyMenuNotifierProvider =
    StateProvider<DailyMenuNotifier?>((_) => null);

class DailyMenuSection extends HookConsumerWidget {
  static final _dialogDateParser = DateFormat('EEEE, dd');

  final DailyMenuNotifier dailyMenuNotifier;
  final void Function()? onTap;

  DailyMenuSection(
    this.dailyMenuNotifier, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('build day: ${dailyMenuNotifier.dailyMenu.day}');

    final padding = const EdgeInsets.fromLTRB(10, 5, 0, 0);

    final primaryColor = dailyMenuNotifier.dailyMenu.isPast
        ? constants.pastColor
        : (dailyMenuNotifier.dailyMenu.isToday
            ? constants.todayColor
            : Colors.amber.shade200);

    final displayEnterNewRecipeCard = useState(false);

    final draggingOverThisWidget = ref.watch(pointerOverWidgetIndexStateProvider
        .select((v) => v == dailyMenuNotifier.dailyMenu.day));

    Widget buildMenuContainer(Meal meal, Menu? menu,
        {bool displayPlaceholder = false}) {
      return _MenuContainer(
        meal,
        key: ValueKey('$meal'),
        menu: menu,
        dailyMenuNotifier: dailyMenuNotifier,
        displayRecipePlaceholder: displayPlaceholder,
      );
    }

    Future<void> addRecipeToMeal(Meal meal, Recipe recipe) async {
      if (dailyMenuNotifier.dailyMenu.getMenuByMeal(meal) == null) {
        final menu = Menu(
          date: dailyMenuNotifier.dailyMenu.day,
          recipes: [recipe.id],
          meal: meal,
        );
        await dailyMenuNotifier.addMenu(menu);
      } else {
        await dailyMenuNotifier.addRecipeToMeal(meal, recipe);
      }
    }

    Future<void> addNewRecipeToMeal(Meal meal, String recipeName) async {
      if (recipeName.trim().isNotEmpty) {
        Recipe recipe = await ref.recipes.save(Recipe(name: recipeName.trim()),
            params: {UPDATE_PARAM: false});
        await addRecipeToMeal(meal, recipe);
      } else {
        print("can't create a recipe with empty name");
      }
    }

    Future<void> newRecipeSubmitted(DailyMenuNotifier dailyMenuNotifier,
        Meal meal, String recipeName) async {
      Recipe? recipe = (await ref.recipes.findAll(remote: false))
          ?.firstWhereOrNull((r) => r.name == recipeName);

      if (recipe == null) {
        await addNewRecipeToMeal(meal, recipeName);
      } else {
        await addRecipeToMeal(meal, recipe);
      }
    }

    return Theme(
      data: Theme.of(context).copyWith(primaryColor: primaryColor),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            _DailyMenuSectionTitle(
              dailyMenuNotifier: dailyMenuNotifier,
              displayEnterNewRecipeCard: displayEnterNewRecipeCard,
            ),
            if (displayEnterNewRecipeCard.value)
              _MealRecipeEditingCard(
                onRecipeMealSubmitted: (meal, recipeName) {
                  newRecipeSubmitted(dailyMenuNotifier, meal, recipeName);
                  displayEnterNewRecipeCard.value = false;
                },
              ),
            ...Meal.values.map((m) {
              final menu = dailyMenuNotifier.dailyMenu.getMenuByMeal(m);

              return buildMenuContainer(m, menu,
                  displayPlaceholder: draggingOverThisWidget);
            }).toList()
          ],
        ),
      ),
    );
  }
}

class _DailyMenuSectionTitle extends HookConsumerWidget {
  final DailyMenuNotifier dailyMenuNotifier;
  final ValueNotifier<bool> displayEnterNewRecipeCard;

  _DailyMenuSectionTitle(
      {required this.dailyMenuNotifier,
      required this.displayEnterNewRecipeCard});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editingMode = ref.watch(isEditingMenuStateProvider);
    final primaryColor = Theme.of(context).primaryColor;

    Widget buildTitleTrailingIcon() {
      if (!displayEnterNewRecipeCard.value)
        return IconButton(
          key: ValueKey('add icon'),
          icon: Icon(
            Icons.add,
            color: Colors.black87,
          ),
          onPressed: () {
            displayEnterNewRecipeCard.value = true;

            // focusNode.requestFocus();
          },
          splashRadius: 15.0,
        );
      else
        return IconButton(
          key: ValueKey('cancel icon'),
          icon: Icon(
            Icons.close,
            color: Colors.black87,
          ),
          onPressed: () {
            displayEnterNewRecipeCard.value = false;
          },
          splashRadius: 15.0,
        );
    }

    return Row(
      key: ValueKey('title'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          softWrap: false,
          textAlign: TextAlign.start,
          text: TextSpan(
            text:
                dailyMenuNotifier.dailyMenu.day.format(_appBarDateParser) + ' ',
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
                text:
                    dailyMenuNotifier.dailyMenu.day.format(_appBarMonthParser),
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
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          child: buildTitleTrailingIcon(),
          width: editingMode ? 40 : 10,
        )
      ],
    );
  }
}

class _MealRecipeCardContainer extends HookConsumerWidget {
  final String recipeId;
  final Meal meal;

  final DailyMenuNotifier dailyMenuNotifier;
  final bool displayLeadingMealIcon;

  const _MealRecipeCardContainer(
    this.meal,
    this.recipeId, {
    Key? key,
    required this.dailyMenuNotifier,
    this.displayLeadingMealIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editingMode = ref.watch(isEditingMenuStateProvider);
    return Row(
      children: [
        _LeadingRecipeIcon(
          iconData: meal.icon,
          color: displayLeadingMealIcon ? Colors.black : Colors.transparent,
        ),
        const SizedBox(width: SPACE_BETWEEN_ICON_AND_CARD),
        Expanded(
          child: Dismissible(
            direction: editingMode
                ? DismissDirection.horizontal
                : DismissDirection.none,
            key: ValueKey("$meal-$recipeId"),
            onDismissed: (_) =>
                dailyMenuNotifier.removeRecipeFromMeal(meal, recipeId),
            child: _MenuRecipeWrapper(
              recipeId,
              meal: meal,
              editingMode: editingMode,
              dailyMenuNotifier: dailyMenuNotifier,
            ),
          ),
        )
      ],
    );
  }
}

class _MenuContainer extends HookConsumerWidget {
  final Meal meal;
  final Menu? menu;
  final DailyMenuNotifier dailyMenuNotifier;
  final bool displayRecipePlaceholder;

  _MenuContainer(
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
      return _MenuRecipeDragTarget(
        menu: menu,
        meal: meal,
        dailyMenuNotifier: dailyMenuNotifier,
        child: Row(
          children: [
            _LeadingRecipeIcon(
              iconData: meal.icon,
              color: displayLeadingMealIcon ? Colors.black : Colors.transparent,
            ),
            const SizedBox(width: SPACE_BETWEEN_ICON_AND_CARD),
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
            .mapIndexed(
              (i, id) => _MealRecipeCardContainer(
                meal,
                id,
                key: ValueKey('$meal-$id'),
                dailyMenuNotifier: dailyMenuNotifier,
                displayLeadingMealIcon: id == recipeIds[0],
              ),
            )
            .toList(),
        if (isDragging && displayRecipePlaceholder)
          buildDragTargetPlaceholder(displayLeadingMealIcon: menu == null),
        if (recipeIds.isNotEmpty) SizedBox(height: 20),
      ],
    );
  }
}

class _MenuRecipeDragTarget extends HookConsumerWidget {
  final Widget child;
  final DailyMenuNotifier dailyMenuNotifier;
  final Menu? menu;
  final Meal? meal;

  final void Function()? onEnter;
  final void Function()? onLeave;

  _MenuRecipeDragTarget({
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
    final dailyMenu = dailyMenuNotifier.dailyMenu;

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
            final menu =
                Menu(date: dailyMenu.day, meal: meal, recipes: recipeIds);
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

class _MenuRecipeWrapper extends HookConsumerWidget {
  final String recipeId;

  final Meal meal;
  final DailyMenuNotifier dailyMenuNotifier;
  final bool editingMode;

  _MenuRecipeWrapper(this.recipeId,
      {required this.meal,
      required this.dailyMenuNotifier,
      this.editingMode = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterDataStateBuilder<Recipe>(
        state: ref.recipes.watchOne(recipeId),
        builder: (context, recipe) {
          return _MenuRecipeCard(recipe,
              meal: meal,
              dailyMenuNotifier: dailyMenuNotifier,
              editingMode: editingMode);
        });
  }
}

class _MenuRecipeCard extends HookConsumerWidget {
  final Recipe recipe;

  final Meal meal;
  final DailyMenuNotifier dailyMenuNotifier;

  final bool editingMode;

  final bool? disabled;

  _MenuRecipeCard(
    this.recipe, {
    Key? key,
    required this.dailyMenuNotifier,
    required this.meal,
    this.disabled = false,
    this.editingMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final heroTag = recipe.id;

    void openRecipeView(Recipe recipe) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecipeScreen(
            recipe,
            heroTag: heroTag,
          ),
        ),
      );
    }

    Widget buildDraggableFeedback(MediaQueryData mediaQuery) {
      return Container(
        decoration: BoxDecoration(borderRadius: MENU_CARD_ROUNDED_RECT_BORDER),
        width: mediaQuery.size.width,
        child: _MenuRecipeCard(
          recipe,
          meal: meal,
          dailyMenuNotifier: dailyMenuNotifier,
        ),
      );
    }

    Widget buildChildWhenDragging(MediaQueryData mediaQuery) {
      return _MenuRecipeCard(
        recipe,
        meal: meal,
        dailyMenuNotifier: dailyMenuNotifier,
        disabled: true,
      );
    }

    Widget buildInfoAndDragSection() {
      return Flexible(
        key: ValueKey('drag-section'),
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
                color: editingMode ? Colors.black38 : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    Future<void> saveRecipe(String recipeName) async {
      //new recipe name changed from the initial one
      if (recipeName.trim().isNotEmpty && recipeName != recipe.name) {
        Recipe? recipe = (await ref.recipes.findAll(remote: false))
            ?.firstWhereOrNull((r) => r.name == recipeName);

        if (recipe == null) {
          if (recipeName.trim().isNotEmpty) {
            recipe = await ref.recipes.save(Recipe(name: recipeName.trim()),
                params: {UPDATE_PARAM: false});
          } else {
            print("can't create a recipe with empty name");
          }
        }
        await dailyMenuNotifier.replaceRecipeInMeal(meal,
            oldRecipeId: this.recipe.id, newRecipeId: recipe!.id);
      }
    }

    Widget buildImageAndTitle() {
      /**
           * GestureDetector & AbsorbPointer below need to stay there to 
           * intercept and inhibits the drag gesture. Could be improved.
           */
      return Flexible(
        key: ValueKey('image-title'),
        flex: 5,
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
                child: Hero(
                  tag: heroTag,
                  child: Image(
                      height: 50,
                      width: 90,
                      image: CachedNetworkImageProvider(recipe.imgUrl!,
                          maxWidth: 236, maxHeight: 131),
                      errorBuilder: (_, __, ___) => Container(),
                      fit: BoxFit.fitWidth),
                ),
              ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(8),
                  child: _RecipeSuggestionTextField(
                    recipeName: recipe.name,
                    autofocus: false,
                    enabled: editingMode,
                    readOnly: !editingMode,
                    onFocusChange: (b) => print('on focus changed $b'),
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                    onEditingComplete: saveRecipe,
                  )),
            ),
          ],
        ),
      );
    }

    return LongPressDraggable<MealRecipe>(
      //delay: Duration(milliseconds: 200),
      /*dragAnchorStrategy: (draggable, context, position) {
        final offset = childDragAnchorStrategy(draggable, context, position);
        return Offset(offset.dx + 45, offset.dy);
      } ,*/
      maxSimultaneousDrags:
          editingMode ? 1 : 0, //disable dragging when not in edit mode
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
          onTap: () {
            if (!editingMode) openRecipeView(recipe);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildImageAndTitle(),
              buildInfoAndDragSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeSuggestionTextField extends HookConsumerWidget {
  final String recipeName;
  final String? hintText;
  final bool showSuggestions;
  final FocusNode? focusNode;
  final void Function(String)? onEditingComplete;
  final Function()? onTap;
  final Function(bool)? onFocusChange;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextStyle? style;

  _RecipeSuggestionTextField({
    String? recipeName,
    this.onEditingComplete,
    this.showSuggestions = true,
    this.onTap,
    this.hintText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = true,
    this.onFocusChange,
    this.focusNode,
    this.style,
  }) : this.recipeName = recipeName ?? '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (focusNode != null) {
      _setupFocusListener();
    }

    final recipeRepository = ref.read(recipesRepositoryProvider);
    final scrollController = useScrollController(keepScrollOffset: false);

    return Autocomplete(
        initialValue: TextEditingValue(text: recipeName),
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          focusNode.addListener(() {
            onFocusChange?.call(focusNode.hasFocus);
          });
          return AutoSizeTextField(
            controller: textEditingController,
            focusNode: focusNode,
            autofocus: autofocus,
            enabled: enabled,
            readOnly: readOnly,
            minLines: 1,
            maxLines: 2,
            style: style,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            scrollController: scrollController,
            //fullwidth: true,
            onSubmitted: (_) => print('submitter'),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            onEditingComplete: () {
              onEditingComplete?.call(textEditingController.text);
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              hintText: hintText,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              isDense: true,
            ),
          );
        },
        optionsBuilder: (textEditingValue) async {
          if (textEditingValue.text.isEmpty) return <Recipe>[];
          if (textEditingValue.text == recipeName) return <Recipe>[];
          return await _suggestionsCallback(
              textEditingValue.text, recipeRepository);
        });
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

enum _MealRecipeEditingCardPhase { MEAL, RECIPE }

class _MealRecipeEditingCard extends StatefulWidget {
  final FocusNode? focusNode;
  final Function(bool)? onFocusChange;
  final Function(Meal, String)? onRecipeMealSubmitted;

  final Meal initialMeal;

  const _MealRecipeEditingCard({
    this.onFocusChange,
    this.focusNode,
    Key? key,
    this.initialMeal = Meal.Breakfast,
    this.onRecipeMealSubmitted,
  }) : super(key: key);

  @override
  State<_MealRecipeEditingCard> createState() => _MealRecipeEditingCardState();
}

class _MealRecipeEditingCardState extends State<_MealRecipeEditingCard> {
  String? recipeName;
  Meal? meal;
  late _MealRecipeEditingCardPhase _mealRecipeEditingCardPhase;

  @override
  void initState() {
    _mealRecipeEditingCardPhase = _MealRecipeEditingCardPhase.MEAL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchOutCurve: Curves.fastOutSlowIn,
      switchInCurve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: _mealRecipeEditingCardPhase == _MealRecipeEditingCardPhase.RECIPE
          ? _buildMenuCardRecipeSelection()
          : _buildMealSelectionWidget(),
    );
  }

  Widget _buildMenuCardRecipeSelection() {
    return Row(
      key: ValueKey('recipe-selection'),
      children: [
        _CardPrototype(
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => setState(() {
              _mealRecipeEditingCardPhase = _MealRecipeEditingCardPhase.MEAL;
            }),
            child: Container(
              margin: _ICON_MARGIN,
              child: Icon(meal?.icon),
            ),
          ),
        ),
        const SizedBox(width: SPACE_BETWEEN_ICON_AND_CARD),
        Expanded(
          child: _CardPrototype(
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(minHeight: 39),
              child: _RecipeSuggestionTextField(
                  hintText: 'Delicious pizza',
                  onEditingComplete: (recipeName) {
                    if (meal != null && recipeName.trim().isNotEmpty) {
                      widget.onRecipeMealSubmitted?.call(meal!, recipeName);
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealSelectionWidget() {
    final primaryColor = Theme.of(context).primaryColor;
    Widget mapMealToWidget(Meal m) {
      return Expanded(
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _mealRecipeEditingCardPhase =
                    _MealRecipeEditingCardPhase.RECIPE;
                meal = m;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(m.icon, color: m == meal ? primaryColor : null),
            )),
      );
    }

    return Row(
      key: ValueKey('meal-selection'),
      children: [
        _LeadingRecipeIcon(iconData: Icons.abc, color: Colors.transparent),
        const SizedBox(width: SPACE_BETWEEN_ICON_AND_CARD),
        Expanded(
          child: _CardPrototype(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Meal.values.map(mapMealToWidget).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeadingRecipeIcon extends StatelessWidget {
  final IconData? iconData;
  final Color? color;

  const _LeadingRecipeIcon({Key? key, this.iconData, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        margin: _ICON_MARGIN,
        child: Icon(
          iconData,
          color: color,
        ),
      ),
    );
  }
}

class _CardPrototype extends StatelessWidget {
  final Widget child;
  final Color? color;
  final ShapeBorder? shape;

  _CardPrototype({
    Key? key,
    ShapeBorder? shape,
    required this.child,
    this.color,
  })  : this.shape = shape ??
            RoundedRectangleBorder(borderRadius: MENU_CARD_ROUNDED_RECT_BORDER),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: shape,
      elevation: 3,
      child: child,
    );
  }
}
