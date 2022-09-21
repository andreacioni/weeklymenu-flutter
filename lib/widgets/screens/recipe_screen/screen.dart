import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../recipe_Screen/recipe_ingredient_modal/recipe_ingredient_modal.dart';
import 'tabs/general_info_tab.dart';
import 'tabs/ingredients_tab.dart';
import '../../../globals/constants.dart';
import '../../../globals/hooks.dart';
import '../../../main.data.dart';
import '../../../globals/errors_handlers.dart';
import '../../shared/editable_text_field.dart';
import 'recipe_ingredient_tile/dismissible_recipe_ingredient.dart';
import 'recipe_information_tiles.dart';
import '../../../models/recipe.dart';
import 'recipe_app_bar.dart';
import 'recipe_tags.dart';
import 'tabs/more_info_tab.dart';

class RecipeScreen extends HookConsumerWidget {
  final Recipe originalRecipeInstance;
  final Object heroTag;

  final RecipeOriginator originator;

  RecipeScreen(this.originalRecipeInstance, {this.heroTag = const Object()})
      : originator = RecipeOriginator(originalRecipeInstance);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editEnabledNotifier = useState(false);
    final recipe = useStateNotifier(originator);
    final editEnabled = editEnabledNotifier.value;

    final autoSizeGroup = AutoSizeGroup();

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
              Icons.more_horiz_rounded,
            ),
            const SizedBox(width: 5),
            AutoSizeText(
              'More',
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

        if (originator.isEdited) {
          print("Saving all recipe changes");

          ref.recipes.save(originator.save(), params: {UPDATE_PARAM: true});
        }
      }

      editEnabledNotifier.value = newValue;
    }

    void _handleBackButton(BuildContext context) async {
      if (originator.isEdited) {
        final wannaSave = await showWannaSaveDialog(context);

        if (wannaSave ?? false) {
          _handleEditToggle(false);
        } else {
          print("Losing all the changes");
          originator.revert();
        }
      } else {
        print("No changes made, not save action is necessary");
      }

      Navigator.of(context).pop();
    }

    void _openAddIngredientModal() async {
      final newRecipeIngredient = await showDialog<RecipeIngredient>(
        context: context,
        barrierDismissible: false,
        builder: (_) => RecipeIngredientModal(),
      );

      final recipeIngredients = recipe.ingredients;

      if (newRecipeIngredient != null) {
        originator.update(recipe.copyWith(
            ingredients: [...recipeIngredients, newRecipeIngredient]));
      } else {
        log("No recipe ingredient to add");
      }
    }

    void handleFloatingButtonActionBasedOnTabIndex() {
      if (tabController.index == 1) {
        _openAddIngredientModal();
      }
    }

    return DefaultTabController(
      length: tabs.length,
      child: WillPopScope(
        onWillPop: () async {
          _handleBackButton(context);
          return true;
        },
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  RecipeAppBar(
                    originator,
                    heroTag: heroTag,
                    editModeEnabled: editEnabled,
                    onRecipeEditEnabled: (editEnabled) =>
                        _handleEditToggle(editEnabled),
                    onBackPressed: () => _handleBackButton(context),
                  ),
                  if (recipe.imgUrl != null)
                    SliverPersistentHeader(
                      delegate: _SliverHeroDelegate(
                        Hero(
                            tag: heroTag,
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  originator.instance.imgUrl!),
                              fit: BoxFit.fitWidth,
                            )),
                      ),
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
              body: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: RecipeGeneralInfoTab(
                      originator: originator,
                      editEnabled: editEnabled,
                    ),
                  ),
                  SingleChildScrollView(
                    child: RecipeIngredientsTab(
                      originator: originator,
                      editEnabled: editEnabled,
                    ),
                  ),
                  SingleChildScrollView(
                    child: RecipeMoreInfoTab(
                      originator: originator,
                      editEnabled: editEnabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: editEnabled
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: handleFloatingButtonActionBasedOnTabIndex,
                )
              : null,
        ),
      ),
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
  final Hero _hero;

  _SliverHeroDelegate(this._hero);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _hero;
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
