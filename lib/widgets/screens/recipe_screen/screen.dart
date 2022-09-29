import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shared/base_dialog.dart';
import 'package:weekly_menu_app/widgets/shared/number_text_field.dart';

import '../../../providers/screen_notifier.dart';
import 'recipe_screen_state_notifier.dart';
import 'tabs/general_info_tab.dart';
import 'tabs/ingredients_tab.dart';
import '../../../globals/constants.dart';
import '../../../globals/hooks.dart';
import '../../../main.data.dart';
import '../../../globals/errors_handlers.dart';
import '../../shared/editable_text_field.dart';
import 'recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import '../../../models/recipe.dart';
import 'recipe_app_bar.dart';
import 'recipe_tags.dart';
import 'tabs/steps_tab.dart';

class RecipeScreen extends HookConsumerWidget {
  final Object heroTag;

  final RecipeOriginator originator;

  RecipeScreen(Recipe originalRecipeInstance, {this.heroTag = const Object()})
      : originator = RecipeOriginator(originalRecipeInstance);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(overrides: [
      recipeScreenNotifierProvider.overrideWithValue(RecipeScreenStateNotifier(
          ref.read, RecipeScreenState(recipeOriginator: originator)))
    ], child: _RecipeScreen(heroTag: heroTag));
  }
}

class _RecipeScreen extends HookConsumerWidget {
  final Object heroTag;

  _RecipeScreen({this.heroTag = const Object()});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final editEnabled =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.editEnabled));
    final displayAddFAB =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.displayFAB));
    final displayServingsFAB = ref.watch(
        recipeScreenNotifierProvider.select((n) => n.displayServingsFAB));
    final servings = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.servs));
    final servingMultiplier =
        ref.read(recipeScreenNotifierProvider).servingsMultiplier;

    final autoSizeGroup = useMemoized(() => AutoSizeGroup());

    final tabs = [
      Tab(
        icon: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.info_outline,
            ),
            const SizedBox(width: 5),
            AutoSizeText(
              'Info',
              group: autoSizeGroup,
              maxLines: 1,
              minFontSize: 1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      Tab(
        icon: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.list,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: AutoSizeText(
                'Ingredients',
                minFontSize: 1,
                maxLines: 1,
                group: autoSizeGroup,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
      Tab(
        icon: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.checklist_rounded,
            ),
            const SizedBox(width: 5),
            AutoSizeText(
              'Steps',
              group: autoSizeGroup,
              minFontSize: 1,
              maxLines: 1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ];

    final tabController = useTabController(
      initialIndex: 0,
      initialLength: tabs.length,
    );
    useEffect(() {
      void listener() {
        _unfocus(context);
        notifier.newIngredientMode = false;
        notifier.newStepMode = false;
        notifier.currentTab = tabController.index;
      }

      tabController.addListener(listener);

      return () => tabController.removeListener(listener);
    }, const []);

    void _handleEditToggle(bool newValue) async {
      //When switching from 'editEnabled = true' to 'editEnabled = false' means we must update resource on remote (if needed)

      if (!newValue) {
        if (!_formKey.currentState!.validate()) {
          print("Validation failed");
          return;
        }
        //This call save the form's state not the recipe. This operation must be done
        // here to trigger all the onSaved callback of the form fields
        _formKey.currentState!.save();

        if (notifier.isRecipeEdited) {
          print("Saving all recipe changes");

          ref.recipes.save(notifier.saveRecipe(), params: {UPDATE_PARAM: true});
        }
      }

      notifier.editEnabled = newValue;
    }

    void _handleBackButton() async {
      if (notifier.edited) {
        final wannaSave = await showWannaSaveDialog(context);

        if (wannaSave ?? false) {
          _handleEditToggle(false);
        } else {
          log("Losing all the changes");
          notifier.revertRecipe();
        }
      } else {
        log("No changes made, not save action is necessary");
      }

      Navigator.of(context).pop();
    }

    void handleAddActionBasedOnTabIndex() {
      if (tabController.index == 1) {
        notifier.newIngredientMode = true;
      } else if (tabController.index == 2) {
        notifier.newStepMode = true;
      }
    }

    void handleServingsChanged() async {
      final newValue = await showDialog(
          context: context,
          builder: (context) {
            return _ServingMultiplierDialog(
              initialValue: servingMultiplier ?? (servings ?? 1),
            );
          });

      if (newValue != null) {
        ref.read(recipeScreenNotifierProvider.notifier).servingsMultiplier =
            newValue;
      }
    }

    Widget? buildFab() {
      if (displayAddFAB) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => handleAddActionBasedOnTabIndex(),
        );
      }

      if (displayServingsFAB) {
        return FloatingActionButton(
          child: Badge(
              elevation: 2,
              alignment: Alignment.topRight,
              position: BadgePosition.topEnd(end: -11, top: -10),
              badgeColor: Theme.of(context).primaryColor,
              badgeContent:
                  Text((servingMultiplier ?? (servings ?? 1)).toString()),
              child: Icon(Icons.people)),
          onPressed: () => handleServingsChanged(),
        );
      }

      return null;
    }

    return ProviderScope(
      overrides: [],
      child: DefaultTabController(
        length: tabs.length,
        child: WillPopScope(
          onWillPop: () async {
            _handleBackButton();
            return true;
          },
          child: Scaffold(
              body: GestureDetector(
                onTap: () => _unfocus(context),
                child: Form(
                  key: _formKey,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        RecipeAppBar(
                          heroTag: heroTag,
                          editModeEnabled: editEnabled,
                          onRecipeEditEnabled: (editEnabled) =>
                              _handleEditToggle(editEnabled),
                          onBackPressed: () => _handleBackButton(),
                        ),
                        SliverPersistentHeader(
                          delegate: _SliverTabBarDelegate(
                            TabBar(
                              tabs: tabs,
                              controller: tabController,
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          SingleChildScrollView(
                            child: RecipeGeneralInfoTab(),
                          ),
                          SingleChildScrollView(
                            child: RecipeIngredientsTab(),
                          ),
                          SingleChildScrollView(
                            child: RecipeStepsTab(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: buildFab()),
        ),
      ),
    );
  }

  void _unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}

class _ServingMultiplierDialog extends HookConsumerWidget {
  final int initialValue;

  _ServingMultiplierDialog({required this.initialValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servingsMultiplier = useState(initialValue);
    return BaseDialog(
      title: 'Servings',
      subtitle: 'For how many people you want to cook?',
      onDoneTap: () => Navigator.of(context).pop(servingsMultiplier.value),
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  splashRadius: 13,
                  onPressed: servingsMultiplier.value > 1
                      ? () => servingsMultiplier.value =
                          servingsMultiplier.value - 1
                      : null,
                  icon: Icon(Icons.remove)),
              Text(servingsMultiplier.value.toString()),
              IconButton(
                  splashRadius: 13,
                  onPressed: () =>
                      servingsMultiplier.value = servingsMultiplier.value + 1,
                  icon: Icon(Icons.add))
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 3,
      child: Container(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class _SliverHeroDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Object tag;

  _SliverHeroDelegate({
    required this.child,
    required this.tag,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Hero(tag: tag, child: child);
  }

  @override
  double get maxExtent => 250;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
