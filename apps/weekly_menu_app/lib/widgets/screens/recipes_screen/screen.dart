import 'dart:developer';
import 'dart:math' hide log;

import 'package:common/constants.dart';
import 'package:common/errors_handlers.dart';
import 'package:common/utils.dart';
import 'package:data/data.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart' hide Provider, Repository;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/recipe.dart';
import 'package:objectid/objectid.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shared/flutter_data_state_builder.dart';

import '../../../services/recipe_scraper_service.dart';
import '../../shared/base_modal_bottom_sheet.dart';
import '../../shared/checkbox_button.dart';
import '../../shared/empty_page_placeholder.dart';
import '../recipe_screen/screen.dart';
import './recipe_card.dart';

class RecipesScreen extends StatefulHookConsumerWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  late bool _searchModeEnabled;
  late String _searchText;

  late bool _editingModeEnabled;
  late List<Recipe> _selectedRecipes;

  @override
  void initState() {
    _searchModeEnabled = false;
    _searchText = "";
    _editingModeEnabled = false;
    _selectedRecipes = <Recipe>[];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.recipes;
    return Scaffold(
      key: widget.key,
      appBar: _editingModeEnabled == false
          ? _buildAppBar(context)
          : _buildEditingAppBar(ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecipeNameDialog(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: buildDataStateBuilder(repository),
    );
  }

  RepositoryStreamBuilder<List<Recipe>> buildDataStateBuilder(
      Repository<Recipe> repository) {
    return RepositoryStreamBuilder<List<Recipe>>(
      stream: repository.stream(),
      notFound: _buildNoRecipesFound(),
      onRefresh: () async => repository.reload(),
      builder: (context, model) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: _buildScreenBody(
            [...model],
            filter: (recipe) => !stringContains(recipe.name, _searchText),
          ),
        );
      },
    );
  }

  Widget _buildScreenBody(List<Recipe> recipes,
      {required bool Function(Recipe) filter}) {
    if (recipes.isNotEmpty) {
      recipes.removeWhere(filter);

      if (recipes.isEmpty && _searchModeEnabled) {
        return EmptyPagePlaceholder(
            icon: Icons.kitchen_outlined, text: 'No personal recipes');
      } else {
        return _buildRecipeList(recipes);
      }
    } else {
      return EmptyPagePlaceholder(
          icon: Icons.kitchen_outlined, text: 'No personal recipes');
    }
  }

  Widget _buildNoRecipesFound() {
    final _textColor = Colors.grey.shade300;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.restaurant,
            size: 130,
            color: _textColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No recipes found",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: _textColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes) {
    return GridView.builder(
      cacheExtent: 2000,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (ctx, index) => Hero(
        tag: recipes[index].idx,
        child: buildRecipeCard(recipes, index, ctx),
      ),
      itemCount: recipes.length,
    );
  }

  Widget buildRecipeCard(List<Recipe> recipes, int index, BuildContext ctx) {
    final recipe = recipes[index];
    return RecipeCard(
      recipe,
      borderSide: _editingModeEnabled == true &&
              _selectedRecipes.contains(recipes[index])
          ? BorderSide(color: Theme.of(ctx).colorScheme.secondary, width: 2)
          : BorderSide.none,
      shadowColorStart: _editingModeEnabled == true &&
              _selectedRecipes.contains(recipes[index])
          ? Theme.of(ctx).colorScheme.secondary.withOpacity(0.7)
          : Colors.black54,
      onTap: () => _editingModeEnabled == true
          ? _addRecipeToEditingList(recipe)
          : _openRecipeView(recipe, heroTag: recipe.idx),
      onLongPress: () =>
          _editingModeEnabled == false ? _enableEditingMode(recipe) : null,
    );
  }

  void _openRecipeView(Recipe recipe,
      {Object heroTag = const Object(), bool unsaved = false}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return RecipeScreen(
          recipe,
          heroTag: heroTag,
          unsaved: unsaved,
        );
      }),
    );
  }

  void _addRecipeToEditingList(Recipe recipe) {
    if (!_selectedRecipes.contains(recipe)) {
      setState(() {
        _selectedRecipes.add(recipe);
      });
    } else {
      setState(() {
        _selectedRecipes.removeWhere((r) => r.idx == recipe.idx);
      });

      if (_selectedRecipes.isEmpty) {
        setState(() => _editingModeEnabled = false);
      }
    }
  }

  void _enableEditingMode(Recipe recipe) {
    setState(() => _editingModeEnabled = true);
    _addRecipeToEditingList(recipe);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: _searchModeEnabled == false
          ? buildAppBarTitle()
          : TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: (text) => setState(() => _searchText = text),
            ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30.0,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        if (_searchModeEnabled == false)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() => _searchModeEnabled = true),
          )
        else
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => setState(() {
              _searchModeEnabled = false;
              _searchText = "";
            }),
          ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: _openOrderingDialog,
        )
      ],
    );
  }

  Widget buildAppBarTitle() {
    return Row(
      children: [
        Text('Recipes'),
      ],
    );
  }

  void _openOrderingDialog() async {}

  AppBar _buildEditingAppBar(WidgetRef ref) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() => _editingModeEnabled = false);
              _selectedRecipes.clear();
            },
          ),
          Text(
            "${_selectedRecipes.length}",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteRecipes(ref),
        )
      ],
    );
  }

  void _deleteRecipes(WidgetRef ref) async {
    var confirmDelete = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Text(
                'Are you sure to delete ${_selectedRecipes.length} recipes? This operation is not reversible'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('CANCEL')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('YES')),
            ],
          );
        });

    if (confirmDelete ?? false) {
      for (var recipe in _selectedRecipes) {
        try {
          await ref.read(recipeRepositoryProvider).delete(recipe);
        } catch (e) {
          showAlertErrorMessage(context);
          return;
        }
      }
    }

    setState(() => _editingModeEnabled = false);
  }

  void _showRecipeNameDialog() async {
    final newRecipe = await showModalBottomSheet<Recipe>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: BOTTOM_SHEET_RADIUS,
        topRight: BOTTOM_SHEET_RADIUS,
      )),
      builder: (_) => _AddRecipeBottomSheet(),
    );

    if (newRecipe != null) {
      _openNewRecipeScreen(newRecipe);
    }
  }

  void _openNewRecipeScreen(Recipe newRecipe) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return RecipeScreen(
          newRecipe,
          unsaved: newRecipe.scraped ?? false,
        );
      }),
    );
  }
}

class _AddRecipeBottomSheet extends HookConsumerWidget {
  _AddRecipeBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final mq = MediaQuery.of(context);
    final maxSheetHeight =
        min<double>(300 + mq.viewInsets.bottom, mq.size.height * 0.7);
    final textType = useState(true);
    final urlType = useState(false);
    final saving = useState(false);
    final doneEnabled = useState(false);

    useEffect((() {
      void listener() {
        if (textController.text.trim().toLowerCase().startsWith("http")) {
          urlType.value = true;
          textType.value = false;
          doneEnabled.value = true;
        } else {
          urlType.value = false;
          textType.value = true;
        }

        if (textController.text.trim().isNotEmpty) {
          doneEnabled.value = true;
        } else {
          doneEnabled.value = false;
        }
      }

      textController.addListener(listener);

      return () => textController.removeListener(listener);
    }), const []);

    return Container(
      height: maxSheetHeight,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                autofocus: false,
                controller: textController,
                decoration:
                    InputDecoration(hintText: textType.value ? "Name" : "URL"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonCheckbox(
                      checked: textType.value,
                      label: Text("Name"),
                      onChanged: (v) {
                        textType.value = v!;
                        urlType.value = !v;
                      }),
                  ButtonCheckbox(
                    checked: urlType.value,
                    label: Text("URL"),
                    onChanged: (v) {
                      urlType.value = v!;
                      textType.value = !v;
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        primary: false,
        bottomSheet: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              child: saving.value
                  ? SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        strokeWidth: 2,
                      ))
                  : Text("Add"),
              onPressed: !saving.value && textController.text.trim().isNotEmpty
                  ? () => onDoneTap(ref, context, textController, saving)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void onDoneTap(WidgetRef ref, BuildContext context,
      TextEditingController controller, ValueNotifier savingNotifier) async {
    Recipe? recipe;

    try {
      savingNotifier.value = true;
      final url = controller.text.trim();
      if (url.toLowerCase().startsWith("https")) {
        recipe = await _scrapeRecipe(ref, url);
        recipe = recipe.copyWith(scraped: true);
      } else if (url.isNotEmpty) {
        recipe = await ref
            .read(recipeRepositoryProvider)
            .save(Recipe(name: controller.text), params: {UPDATE_PARAM: false});
      } else {
        log("No name supplied");
      }

      Navigator.of(context).pop(recipe);
    } catch (e) {
      log("failed to save a new recipe: $recipe", error: e);
      savingNotifier.value = false;
    }
  }

  Future<Recipe> _scrapeRecipe(WidgetRef ref, String url) async {
    final scraper = ref.read(recipeScraperProvider);
    final recipe = await scraper.scrapeUrl(url);
    return recipe;
  }
}
