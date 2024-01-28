import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:model/recipe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weekly_menu_app/widgets/shared/app_bar.dart';
import 'package:weekly_menu_app/widgets/shared/bottom_sheet.dart';
import 'package:weekly_menu_app/widgets/shared/shimmer.dart';
import '../../../providers/user_preferences.dart';
import '../../shared/recipe_card.dart';

const _PER_PAGE = 10;

class ExploreRecipesScreen extends StatefulWidget {
  @override
  State<ExploreRecipesScreen> createState() => _ExploreRecipesScreenState();
}

class _ExploreRecipesScreenState extends State<ExploreRecipesScreen> {
  String searchText = "";

  _ExploreRecipesScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        leadingIcon: Icon(Icons.arrow_back),
        onLeadingTap: () => Navigator.of(context).pop(),
        onSearchTextSubmitted: (text) {
          setState(() => searchText = text);
        },
      ),
      body: _ExploreRecipeTab(
        searchText: searchText,
      ),
    );
  }
}

class _ExploreRecipeTab extends HookConsumerWidget {
  final String searchText;

  _ExploreRecipeTab({
    this.searchText = "",
  });

  void exploreRecipeBottomSheet(BuildContext context, Recipe recipe) async {
    final linkTextTheme = Theme.of(context).textTheme.labelLarge!;
    final labelTextTheme = Theme.of(context).textTheme.labelMedium!;

    final recipeUri =
        recipe.recipeUrl != null ? Uri.parse(recipe.recipeUrl!) : null;
    await showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return BaseBottomSheet(
            appBarTitle: "Open recipe",
            actionButtonText: "Open",
            actionButtonIcon: Icon(Icons.public),
            onTap: recipe.recipeUrl != null
                ? () async {
                    if (!await launchUrl(Uri.parse(recipe.recipeUrl!))) {
                      throw 'Could not launch ${recipe.recipeUrl}';
                    }
                  }
                : null,
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  Row(children: [
                    Flexible(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                            errorWidget: (_, __, ___) => Container(),
                            imageUrl: recipe.imgUrl ??
                                "http://invalidaddress.org/img.png",
                            maxWidthDiskCache: 150,
                            maxHeightDiskCache: 150,
                          ),
                        ),
                      ),
                      flex: 10,
                    ),
                    Spacer(),
                    Flexible(
                      child: Text(
                        recipe.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      flex: 30,
                    )
                  ]),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: labelTextTheme.color),
                          Text("2",
                              style: labelTextTheme.copyWith(
                                  color:
                                      labelTextTheme.color!.withOpacity(0.5)))
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.shopping_bag, color: labelTextTheme.color),
                          Text("4",
                              style: labelTextTheme.copyWith(
                                  color:
                                      labelTextTheme.color!.withOpacity(0.5)))
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.favorite_border,
                              color: labelTextTheme.color),
                          Text("85%",
                              style: labelTextTheme.copyWith(
                                  color:
                                      labelTextTheme.color!.withOpacity(0.5)))
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      if (recipeUri != null)
                        Text(
                          recipeUri.host,
                          style: linkTextTheme.copyWith(
                              fontStyle: FontStyle.italic,
                              color: linkTextTheme.color!.withOpacity(0.5)),
                        )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.externalRecipes;
    final userPrefs = ref.read(userPreferenceProvider);
    final theme = Theme.of(context);

    final pageNumber = useState(1);
    final recipes = useState(<ExternalRecipe>[]);
    final oldSearchText = useRef("");
    final Map<String, Object> params = {
      'per_page': _PER_PAGE,
      'page': pageNumber.value
    };

    if (searchText.isNotEmpty) {
      params['text_search'] = searchText;
      params['order_by'] = 'text_score';
      if (userPrefs?.language != null) {
        params['lang'] = userPrefs!.language!;
      }
    }

    final recipesFuture = useMemoized(
        () => repository.loadAll(params: params).then((value) {
              if (oldSearchText != searchText) {
                oldSearchText.value = searchText;
                recipes.value = [...value];
                pageNumber.value = 1;
              } else {
                recipes.value = [...recipes.value, ...value];
              }

              return value.length;
            }),
        [pageNumber.value, searchText]);

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
        GridView.builder(
          cacheExtent: 20,
          padding: EdgeInsets.zero,
          physics:
              NeverScrollableScrollPhysics(), // to disable GridView's scrolling
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) => Hero(
            tag: recipes.value[index].idx,
            child: RecipeCard(
              recipes.value[index],
              onTap: () =>
                  exploreRecipeBottomSheet(context, recipes.value[index]),
            ),
          ),
          itemCount: recipes.value.length,
        ),
        FutureBuilder(
            future: recipesFuture,
            builder: (context, snapshot) {
              final retrivedRecipesNumber = snapshot.data;
              return snapshot.connectionState == ConnectionState.done
                  ? Container(
                      height: 100,
                      child: Center(
                        child: ElevatedButton(
                          child: Text("Load More"),
                          onPressed: !snapshot.hasError &&
                                  _PER_PAGE == retrivedRecipesNumber
                              ? () {
                                  pageNumber.value += 1;
                                }
                              : null,
                        ),
                      ),
                    )
                  : _LoadingGrid();
            })
      ],
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      cacheExtent: 20,
      padding: EdgeInsets.zero,
      physics:
          const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: DefaultShimmer(),
      ),
      itemCount: _PER_PAGE,
    );
  }
}
