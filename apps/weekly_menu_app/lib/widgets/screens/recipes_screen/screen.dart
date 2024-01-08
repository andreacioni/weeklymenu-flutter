import 'dart:developer';
import 'dart:math' hide log;

import 'package:common/constants.dart';
import 'package:common/errors_handlers.dart';
import 'package:common/utils.dart';
import 'package:data/api/recipe_scraper_service.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:model/recipe.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weekly_menu_app/widgets/shared/appbar_button.dart';
import 'package:weekly_menu_app/widgets/shared/flutter_data_state_builder.dart';

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

class _RecipesScreenState extends ConsumerState<RecipesScreen>
    with SingleTickerProviderStateMixin {
  late String _searchText;

  late bool _editingModeEnabled;
  late List<Recipe> _selectedRecipes;

  late TabController _tabController;

  @override
  void initState() {
    _searchText = "";
    _editingModeEnabled = false;
    _selectedRecipes = <Recipe>[];
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: _AppBar(
        tabController: _tabController,
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _MyRecipesTab(
            searchText: _searchText,
            editingModeEnabled: _editingModeEnabled,
            selectedRecipes: _selectedRecipes,
            onRecipeTap: (recipe) => _editingModeEnabled == true
                ? _addRecipeToEditingList(recipe)
                : _openRecipeView(context, recipe, heroTag: recipe.idx),
            onRecipeLongPress: (recipe) => _editingModeEnabled == false
                ? _enableEditingMode(recipe)
                : null,
          ),
          _ExploreRecipeTab(
            searchText: _searchText,
          )
        ],
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

class _MyRecipesTab extends HookConsumerWidget {
  final String searchText;
  final bool editingModeEnabled;
  final List<Recipe> selectedRecipes;

  final ValueChanged<Recipe>? onRecipeTap;
  final ValueChanged<Recipe>? onRecipeLongPress;

  _MyRecipesTab(
      {required this.searchText,
      required this.editingModeEnabled,
      required this.selectedRecipes,
      this.onRecipeLongPress,
      this.onRecipeTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onRefresh: () async => repository.reload(),
          builder: (context, model) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _buildScreenBody(
                context,
                [...model],
                filter: (recipe) => !stringContains(recipe.name, searchText),
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
        borderSide: editingModeEnabled == true &&
                selectedRecipes.contains(recipes[index])
            ? BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2)
            : BorderSide.none,
        shadowColorStart: editingModeEnabled == true &&
                selectedRecipes.contains(recipes[index])
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
            : Colors.black54,
        onTap: () => onRecipeTap?.call(recipe),
        onLongPress: () => onRecipeLongPress?.call(recipe));
  }
}

class _ExploreRecipeTab extends HookConsumerWidget {
  final String searchText;

  _ExploreRecipeTab({
    required this.searchText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.externalRecipes;
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
        RepositoryFutureBuilder(
          future: repository.loadAll(),
          builder: ((context, recipes) {
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
                child: RecipeCard(
                  recipes[index],
                ),
              ),
              itemCount: recipes.length,
            );
          }),
        ),
        Container(
          height: 100,
          child: Center(
            child: Text("Load more"),
          ),
        )
      ],
    );
  }
}

class _AddRecipeBottomSheet extends HookConsumerWidget {
  _AddRecipeBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    final maxSheetHeight =
        min<double>(300 + mq.viewInsets.bottom, mq.size.height * 0.7);
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
                        color: theme.scaffoldBackgroundColor,
                        strokeWidth: 2,
                      ))
                  : Text("Add"),
              onPressed: !saving.value && textController.text.trim().isNotEmpty
                  ? () => onDoneTap(
                      ref, context, textController, saving, errorMessage)
                  : null,
            ),
          ),
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

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchTextChanged;
  final TabController tabController;

  _AppBar({required this.tabController, this.onSearchTextChanged});

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(110);
}

class _AppBarState extends State<_AppBar> with SingleTickerProviderStateMixin {
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  late bool hasFocus;

  @override
  void initState() {
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    hasFocus = false;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final osTopPadding = MediaQuery.of(context).padding.top;

    focusNode.addListener(() {
      setState(() => hasFocus = focusNode.hasFocus);
    });

    return Stack(
      children: [
        Material(
          elevation: appBarTheme.elevation ?? 0,
          child: Container(
            height: osTopPadding,
            color: appBarTheme.backgroundColor,
          ),
        ),
        AppBar(
          toolbarHeight: 100,
          title: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    suffixIcon:
                        textEditingController.text.isNotEmpty || hasFocus
                            ? IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  textEditingController.clear();
                                  this.widget.onSearchTextChanged?.call("");
                                },
                              )
                            : Icon(Icons.search)),
                onChanged: (text) {
                  this.widget.onSearchTextChanged?.call(text);
                },
              ),
            ),
          ),
          leading: Transform.scale(
            scale: 0.85,
            child: AppBarButton(
              icon: Icon(Icons.menu),
              onPressed: () =>
                  Scaffold.of(Scaffold.of(context).context).openDrawer(),
            ),
          ),
          actions: <Widget>[
            AppBarButton(
              icon: Icon(
                Icons.filter_list,
              ),
              onPressed: _openOrderingDialog,
            )
          ],
          bottom: TabBar(
            controller: widget.tabController,
            tabs: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline),
                    Text("My Recipe"),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public),
                    Text("Explore"),
                  ],
                ),
              ),
            ],
            onTap: (idx) {
              widget.tabController.index = idx;
            },
          ),
        ),
      ],
    );
  }

  void _openOrderingDialog() async {}
}
