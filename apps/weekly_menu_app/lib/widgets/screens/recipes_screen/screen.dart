import 'dart:developer';

import 'package:common/constants.dart';
import 'package:common/errors_handlers.dart';
import 'package:common/utils.dart';
import 'package:data/api/recipe_scraper_service.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/recipe.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shared/bottom_sheet.dart';

import '../../../providers/user_preferences.dart';
import '../../shared/app_bar.dart';
import '../../shared/flutter_data_state_builder.dart';
import '../../shared/checkbox_button.dart';
import '../../shared/empty_page_placeholder.dart';
import '../recipe_screen/screen.dart';
import '../../shared/recipe_card.dart';

class RecipesScreen extends StatefulHookConsumerWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen>
    with SingleTickerProviderStateMixin {
  late String _searchText;

  late bool _editingModeEnabled;
  late List<Recipe> _selectedRecipes;

  @override
  void initState() {
    _searchText = "";
    _editingModeEnabled = false;
    _selectedRecipes = <Recipe>[];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: SearchAppBar(
        onLeadingTap: () => Scaffold.of(context).openDrawer(),
        onSearchTextChanged: ((searchText) => setState(() {
              _searchText = searchText;
            })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecipeNameDialog(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () => ref.recipes.reload(),
        displacement: 105,
        child: _MyRecipesTab(
          searchText: _searchText,
          editingModeEnabled: _editingModeEnabled,
          selectedRecipes: _selectedRecipes,
          onRecipeTap: (recipe) => _editingModeEnabled == true
              ? _addRecipeToEditingList(recipe)
              : _openRecipeView(context, recipe, heroTag: recipe.idx),
          onRecipeLongPress: (recipe) =>
              _editingModeEnabled == false ? _enableEditingMode(recipe) : null,
        ),
      ),
    );
  }

  void _enableEditingMode(Recipe recipe) {
    setState(() => _editingModeEnabled = true);
    _addRecipeToEditingList(recipe);
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

  Widget buildAppBarTitle() {
    return Row(
      children: [
        Text('Recipes'),
      ],
    );
  }

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
          await ref.read(recipeRepositoryProvider).delete(recipe.idx);
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

  void _openRecipeView(BuildContext context, Recipe recipe,
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
}

class _MyRecipesTab extends StatefulHookConsumerWidget {
  final String searchText;
  final bool editingModeEnabled;
  final List<Recipe> selectedRecipes;

  final ValueChanged<Recipe>? onRecipeTap;
  final ValueChanged<Recipe>? onRecipeLongPress;

  _MyRecipesTab({
    required this.searchText,
    required this.editingModeEnabled,
    required this.selectedRecipes,
    this.onRecipeLongPress,
    this.onRecipeTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyRecipesTabState();
  }
}

class _MyRecipesTabState extends ConsumerState<_MyRecipesTab>
    with AutomaticKeepAliveClientMixin<_MyRecipesTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final repository = ref.recipes;
    final recipeStream = useMemoized(() => repository.stream());
    final theme = Theme.of(context);

    return ListView(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              InputChip(
                backgroundColor: theme.colorScheme.background,
                selectedColor: theme.primaryColorLight,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: theme.colorScheme.secondary),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                label: Text("Month recipes"),
                onPressed: () {},
              ),
              SizedBox(width: 10),
              InputChip(
                  backgroundColor: theme.colorScheme.background,
                  selectedColor: theme.primaryColorLight,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.secondary),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  selected: true,
                  label: Text("Most cooked"),
                  onPressed: () {}),
              SizedBox(width: 10),
              InputChip(
                  backgroundColor: theme.colorScheme.background,
                  selectedColor: theme.primaryColorLight,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.secondary),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  label: Text("Seasonal"),
                  onPressed: () {}),
              SizedBox(width: 10),
              InputChip(
                  backgroundColor: theme.colorScheme.background,
                  selectedColor: theme.primaryColorLight,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.secondary),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  label: Text("Fast"),
                  onPressed: () {}),
            ],
          ),
        ),
        Divider(),
        RepositoryStreamBuilder<List<Recipe>>(
          stream: recipeStream,
          notFound: _buildNoRecipesFound(),
          //no more working after adding search bar and filter below standard appbar
          onRefresh: () async => repository.reload(),
          builder: (context, model) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _buildScreenBody(
                context,
                [...model],
                filter: (recipe) =>
                    !stringContains(recipe.name, widget.searchText),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildScreenBody(BuildContext context, List<Recipe> recipes,
      {required bool Function(Recipe) filter}) {
    if (recipes.isNotEmpty) {
      recipes.removeWhere(filter);
      return _buildRecipeList(context, recipes);
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

  Widget _buildRecipeList(BuildContext context, List<Recipe> recipes) {
    return GridView.builder(
      cacheExtent: 20,
      padding: EdgeInsets.zero,
      physics:
          NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) => Hero(
        tag: recipes[index].idx,
        child: buildRecipeCard(context, recipes, index),
      ),
      itemCount: recipes.length,
    );
  }

  Widget buildRecipeCard(
      BuildContext context, List<Recipe> recipes, int index) {
    final recipe = recipes[index];
    return RecipeCard(recipe,
        borderSide: widget.editingModeEnabled == true &&
                widget.selectedRecipes.contains(recipes[index])
            ? BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2)
            : BorderSide.none,
        shadowColorStart: widget.editingModeEnabled == true &&
                widget.selectedRecipes.contains(recipes[index])
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
            : Colors.black54,
        onTap: () => widget.onRecipeTap?.call(recipe),
        onLongPress: () => widget.onRecipeLongPress?.call(recipe));
  }

  @override
  bool get wantKeepAlive => true;
}

class _AddRecipeBottomSheet extends HookConsumerWidget {
  _AddRecipeBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final theme = Theme.of(context);
    final textType = useState(true);
    final urlType = useState(false);
    final saving = useState(false);
    final doneEnabled = useState(false);
    final errorMessage = useState("");

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

    return BaseBottomSheet(
      maxSize: 0.5,
      actionButtonText: "Add",
      loading: saving.value,
      onTap: !saving.value && textController.text.trim().isNotEmpty
          ? () => onDoneTap(ref, context, textController, saving, errorMessage)
          : null,
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
            ),
            SizedBox(height: 20),
            if (errorMessage.value.isNotEmpty)
              Text(
                errorMessage.value,
                style: TextStyle(color: theme.colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }

  void onDoneTap(
      WidgetRef ref,
      BuildContext context,
      TextEditingController controller,
      ValueNotifier<bool> savingNotifier,
      ValueNotifier errorMsgNotifier) async {
    Recipe? recipe;

    errorMsgNotifier.value = "";

    final language = ref.read(languageProvider);

    try {
      savingNotifier.value = true;
      final url = controller.text.trim();
      if (url.toLowerCase().startsWith("https")) {
        recipe = await _scrapeRecipe(ref, url);
        recipe = recipe.copyWith(scraped: true);
      } else if (url.isNotEmpty) {
        recipe = await ref.read(recipeRepositoryProvider).save(
            Recipe(name: controller.text, language: language),
            params: {UPDATE_PARAM: false});
      } else {
        log("No name supplied");
      }

      Navigator.of(context).pop(recipe);
    } catch (e) {
      log("failed to save a new recipe: $recipe", error: e);
      errorMsgNotifier.value =
          "Error retrieving recipe from URL. Please check if the URL is valid and reachable and then try again.";
      savingNotifier.value = false;
    }
  }

  Future<Recipe> _scrapeRecipe(WidgetRef ref, String url) async {
    final scraper = ref.read(recipeScraperProvider);
    final recipe = await scraper.scrapeUrl(url);
    return recipe;
  }
}
