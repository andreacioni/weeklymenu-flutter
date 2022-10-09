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

    Future<void> showAddInfoDialog() async {
      await showDialog(
          context: context,
          builder: (context) => BaseDialog(
                title: "New section",
                subtitle: "Add more information to your recipe",
                children: [
                  ListTile(
                      leading: Icon(Icons.restaurant), title: Text("Section")),
                  ListTile(
                      leading: Icon(Icons.description_outlined),
                      title: Text("Description")),
                  ListTile(
                      leading: Icon(Icons.assignment_outlined),
                      title: Text("Note")),
                  ListTile(leading: Icon(Icons.euro), title: Text("Cost")),
                  ListTile(
                      leading: Icon(Icons.local_fire_department_outlined),
                      title: Text("Calories")),
                  ListTile(
                      leading: Icon(Icons.ondemand_video),
                      title: Text("Video")),
                  ListTile(leading: Icon(Icons.link), title: Text("Link")),
                ],
              ));
    }

    void handleAddActionBasedOnTabIndex() {
      if (tabController.index == 0) {
        showAddInfoDialog();
      } else if (tabController.index == 1) {
        notifier.newIngredientMode = true;
      } else if (tabController.index == 2) {
        notifier.newStepMode = true;
      }
    }

    Widget? buildFab() {
      if (displayAddFAB) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => handleAddActionBasedOnTabIndex(),
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
                          tabs: tabs,
                          tabController: tabController,
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
