import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/screens/recipe_screen/update_general_info_bottom_sheet.dart';

import '../../../globals/utils.dart';
import '../../../providers/screen_notifier.dart';
import 'recipe_screen_state_notifier.dart';
import 'tabs/general_info_tab.dart';
import 'tabs/ingredients_tab.dart';
import '../../../globals/constants.dart';
import '../../../main.data.dart';
import '../../../globals/errors_handlers.dart';
import '../../../models/recipe.dart';
import 'recipe_app_bar.dart';
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
        ref.watch(recipeScreenNotifierProvider.select((n) => n.displayAddFAB));
    final displayServingsFAB = ref.watch(
        recipeScreenNotifierProvider.select((n) => n.displayServingsFAB));
    final displayMoreFAB =
        ref.watch(recipeScreenNotifierProvider.select((n) => n.displayMoreFAB));

    final servings = ref.watch(recipeScreenNotifierProvider
            .select((n) => n.recipeOriginator.instance.servs)) ??
        1;
    final servingsMultiplier = ref.watch(
            recipeScreenNotifierProvider.select((n) => n.servingsMultiplier)) ??
        servings;

    final autoSizeGroup = useMemoized(() => AutoSizeGroup());

    final theme = Theme.of(context);

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
        unfocus(context);
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

    Future<void> showAddInfoDialog() async {
      final radius = const Radius.circular(20);

      final recipe =
          ref.read(recipeScreenNotifierProvider).recipeOriginator.instance;
      final newRecipe = await showModalBottomSheet<Recipe?>(
        context: context,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        ),
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (context) => UpdateGeneralInfoRecipeBottomSheet(
          recipe: recipe,
          notifier: notifier,
        ),
      );

      if (newRecipe != null) {
        notifier.updateRecipe(newRecipe);
      }
    }

    void handleAddActionBasedOnTabIndex() {
      unfocus(context);
      if (tabController.index == 1) {
        //give some time for the keyboard to disappear
        //and then trigger the "new ingredient mode" event
        Future.delayed(Duration(milliseconds: 100),
            () => notifier.newIngredientMode = true);
      } else if (tabController.index == 2) {
        notifier.newStepMode = true;
      }
    }

    Widget? buildFab() {
      final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

      if (showFab) {
        if (displayServingsFAB) {
          return Card(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    splashRadius: 13,
                    onPressed: servingsMultiplier > 1
                        ? () =>
                            notifier.servingsMultiplier = servingsMultiplier - 1
                        : null,
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.amber.shade400,
                    )),
                Text(
                  servingsMultiplier.toString(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.people_outline,
                ),
                IconButton(
                    splashRadius: 13,
                    onPressed: () =>
                        notifier.servingsMultiplier = servingsMultiplier + 1,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.amber.shade400,
                    ))
              ],
            ),
          );
        } else if (displayAddFAB) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => handleAddActionBasedOnTabIndex(),
          );
        } else if (displayMoreFAB) {
          return FloatingActionButton(
            mini: true,
            child: Icon(Icons.keyboard_arrow_up_rounded),
            onPressed: () => showAddInfoDialog(),
          );
        }
      }

      return null;
    }

    return Theme(
      data: theme.copyWith(
          cardTheme: theme.cardTheme.copyWith(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      child: ProviderScope(
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
                onTap: () => unfocus(context),
                child: Form(
                  key: _formKey,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: RecipeAppBar(
                            heroTag: heroTag,
                            editModeEnabled: editEnabled,
                            onRecipeEditEnabled: (editEnabled) =>
                                _handleEditToggle(editEnabled),
                            onBackPressed: () => _handleBackButton(),
                            tabs: tabs,
                            tabController: tabController,
                            innerBoxIsScrolled: innerBoxIsScrolled,
                          ),
                        )
                      ];
                    },
                    body: Padding(
                        padding: const EdgeInsets.only(top: 115),
                        child: SafeArea(
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
                        )),
                  ),
                ),
              ),
              floatingActionButton: buildFab(),
              floatingActionButtonLocation: displayServingsFAB
                  ? FloatingActionButtonLocation.centerFloat
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
