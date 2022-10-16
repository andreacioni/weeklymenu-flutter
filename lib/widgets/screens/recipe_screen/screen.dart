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

    Future<String?> showTextDialog(String? initialText, String title) async {
      final controller = TextEditingController(text: initialText);

      return await showDialog<String?>(
          context: context,
          builder: (context) {
            return BaseDialog(
                title: 'Description',
                children: [
                  TextField(
                    controller: controller,
                  ),
                ],
                onDoneTap: () =>
                    Navigator.pop(context, controller.text.trim()));
          });
    }

    Future<void> showAddInfoDialog() async {
      final recipe =
          ref.read(recipeScreenNotifierProvider).recipeOriginator.instance;
      await showDialog(
          context: context,
          builder: (context) => BaseDialog(
                title: "More",
                subtitle: "Add or modify additional information",
                displayActions: false,
                children: [
                  ListTile(
                    leading: Icon(Icons.restaurant),
                    title: Text("Section"),
                    trailing: recipe.section != null
                        ? Icon(Icons.check_circle_outline)
                        : null,
                    onTap: () async {
                      final newSection =
                          await showTextDialog(recipe.section, 'Section');
                      if (newSection != null) {
                        notifier.updateSection(newSection);
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.description_outlined),
                    title: Text("Description"),
                    trailing: recipe.description != null
                        ? Icon(Icons.check_circle_outline)
                        : null,
                    onTap: () async {
                      final newDesc =
                          await showTextDialog(recipe.note, 'Description');
                      if (newDesc != null) {
                        notifier.updateDescription(newDesc);
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_outlined),
                    title: Text("Note"),
                    trailing: recipe.note != null
                        ? Icon(Icons.check_circle_outline)
                        : null,
                    onTap: () async {
                      final newNote =
                          await showTextDialog(recipe.note, 'Notes');
                      if (newNote != null) {
                        notifier.updateNote(newNote);
                      }
                    },
                  ),
                  ListTile(
                      leading: Icon(Icons.local_fire_department_outlined),
                      title: Text("Calories")),
                  ListTile(
                      leading: Icon(Icons.ondemand_video),
                      title: Text("Video"),
                      trailing: recipe.videoUrl != null
                          ? Icon(Icons.check_circle_outline)
                          : null,
                      onTap: () async {
                        final newVideoUrl = await showTextDialog(null, 'Video');
                        if (newVideoUrl != null) {
                          notifier.updateVideoUrl(newVideoUrl);
                        }
                      }),
                  ListTile(
                      leading: Icon(Icons.link),
                      title: Text("Link"),
                      trailing: recipe.recipeUrl != null
                          ? Icon(Icons.check_circle_outline)
                          : null,
                      onTap: () async {
                        final newLink = await showTextDialog(null, 'Link');
                        if (newLink != null) {
                          notifier.updateRecipeUrl(newLink);
                        }
                      }),
                  ListTile(leading: Icon(Icons.euro), title: Text("Cost")),
                  ListTile(
                    leading: Icon(Icons.tag),
                    title: Text("Tags"),
                    trailing: recipe.tags.isNotEmpty
                        ? Icon(Icons.check_circle_outline)
                        : null,
                    onTap: () async {
                      final newTag = await showTextDialog(null, 'Tag');
                      if (newTag != null) {
                        notifier.addTag(newTag);
                      }
                    },
                  ),
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
                onTap: () => _unfocus(context),
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
                        padding: const EdgeInsets.only(
                            top: 115, left: 8, right: 8, bottom: 8),
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

  void _unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}
