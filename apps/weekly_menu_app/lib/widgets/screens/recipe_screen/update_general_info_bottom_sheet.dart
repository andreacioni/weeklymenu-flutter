import 'dart:async';
import 'dart:math' hide log;

import 'package:common/utils.dart';
import 'package:data/repositories.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/recipe.dart';

import 'notifier.dart';
import '../../shared/base_dialog.dart';

final _stateProvider = StateProvider<_fields?>((_) => null);

final _recipesSuggestionsProvider = FutureProvider.autoDispose((ref) async =>
    await ref.read(recipeRepositoryProvider).loadAll(remote: false));
final _tagSuggestionProvider = FutureProvider.autoDispose((ref) async {
  final recipes = await ref.watch(_recipesSuggestionsProvider.future);
  return recipes.map((r) => r.tags).flattened.toSet();
});
final _resolvedRelatedRecipesProvider = FutureProvider.autoDispose
    .family<List<Recipe>, List<RelatedRecipe>>((ref, relatedRecipes) async {
  final recipes = await ref.watch(_recipesSuggestionsProvider.future);
  return relatedRecipes
      .map((rr) => recipes.firstWhereOrNull((r) => r.idx == rr.id))
      .where((r) => r != null)
      .toList()
      .cast();
});

enum _fields { section, description, note, related_recipes, video, link, tags }

class UpdateGeneralInfoRecipeBottomSheet extends HookConsumerWidget {
  final Recipe recipe;
  final RecipeScreenStateNotifier notifier;

  UpdateGeneralInfoRecipeBottomSheet(
      {required this.recipe, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    useEffect(() {
      void listener() {}

      tabController.addListener(listener);

      return () => tabController.removeListener(listener);
    }, const []);

    final tabs = [
      _UpdateGeneralInfoMainTab(
        recipe: recipe,
        notifier: notifier,
        tabController: tabController,
        onTap: (selection) {
          ref.read(_stateProvider.notifier).state = selection;
          tabController.index = 1;
        },
      ),
      _UpdateSpecificFieldTab(
        recipe: recipe,
        notifier: notifier,
        tabController: tabController,
        onDone: (newRecipe) => Navigator.of(context).pop(newRecipe),
      )
    ];

    final mq = MediaQuery.of(context);

    final maxSheetHeight =
        min<double>(500 + mq.viewInsets.bottom, mq.size.height * 0.8);

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: DefaultTabController(
        length: tabs.length,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: tabs,
        ),
      ),
    );
  }
}

class _UpdateSpecificFieldTab extends HookConsumerWidget {
  final Recipe recipe;
  final RecipeScreenStateNotifier notifier;
  final TabController tabController;
  final void Function(Recipe)? onDone;

  const _UpdateSpecificFieldTab({
    Key? key,
    required this.recipe,
    required this.notifier,
    required this.tabController,
    this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final innerScreen = ref.watch(_stateProvider);

    var tempRecipe = recipe.copyWith();

    final recipes = ref.watch(_recipesSuggestionsProvider).map(
        data: (data) => data.value,
        error: (_) => const <Recipe>[],
        loading: (_) => const <Recipe>[]);
    final tags = ref.watch(_tagSuggestionProvider).map(
        data: (data) => data.value,
        error: (_) => const <String>[],
        loading: (_) => const <String>[]);

    final resolvedRelatedRecipes = ref
        .watch(_resolvedRelatedRecipesProvider(recipe.relatedRecipes))
        .map(
            data: (data) => data.value,
            error: (_) => const <Recipe>[],
            loading: (_) => const <Recipe>[]);

    Widget? _displayInnerScreen() {
      return {
        _fields.section: _UpdateTextualValue(
          key: ValueKey(_fields.section),
          initialValue: recipe.section,
          maxLength: 50,
          onChanged: (text) =>
              tempRecipe = tempRecipe.copyWith(section: text.trim()),
        ),
        _fields.description: _UpdateTextualValue(
          key: ValueKey(_fields.description),
          initialValue: recipe.description,
          maxLength: 100,
          onChanged: (text) =>
              tempRecipe = tempRecipe.copyWith(description: text.trim()),
        ),
        _fields.note: _UpdateTextualValue(
          key: ValueKey(_fields.note),
          initialValue: recipe.note,
          maxLength: 500,
          multiline: true,
          onChanged: (text) =>
              tempRecipe = tempRecipe.copyWith(note: text.trim()),
        ),
        _fields.related_recipes: _MultiValueSelectWithSuggestion<Recipe>(
          key: ValueKey(_fields.related_recipes.toString() +
              resolvedRelatedRecipes.hashCode.toString()),
          textFieldSuffixIcon: Icon(Icons.search_outlined),
          currentlySelected: resolvedRelatedRecipes,
          suggestionsCallback: (text) async {
            if (text.trim().isEmpty) {
              return const [];
            }
            return recipes
                .where((r) => r.name.toLowerCase().contains(text.toLowerCase()))
                .where((r) =>
                    tempRecipe.relatedRecipes
                        .firstWhereOrNull((rr) => r.idx == rr.id) ==
                    null)
                .toList();
          },
          onSelectionChanged: (selected) {
            final relatedRecipes =
                selected.map((r) => RelatedRecipe(id: r.idx)).toList();
            tempRecipe = tempRecipe.copyWith(relatedRecipes: relatedRecipes);
          },
        ),
        _fields.video: _UpdateTextualValue(
          key: ValueKey(_fields.video),
          initialValue: recipe.videoUrl,
          maxLength: 200,
          onChanged: (text) =>
              tempRecipe = tempRecipe.copyWith(videoUrl: text.trim()),
        ),
        _fields.link: _UpdateTextualValue(
          key: ValueKey(_fields.link),
          initialValue: recipe.recipeUrl,
          maxLength: 200,
          onChanged: (text) =>
              tempRecipe = tempRecipe.copyWith(recipeUrl: text.trim()),
        ),
        _fields.tags: _MultiValueTextWithSuggestion<String>(
          key: ValueKey(_fields.link),
          currentlySelected: recipe.tags,
          textToTypeConverter: (text) => text,
          submitButtonIcon: Icon(Icons.add),
          suggestionsCallback: (text) async {
            if (text.trim().isEmpty) {
              return const <String>[];
            }
            return tags
                .where((t) => t.toLowerCase().contains(text.toLowerCase()))
                .where((t) =>
                    tempRecipe.tags.firstWhereOrNull((tt) => t == tt) == null)
                .toList();
          },
          onSelectionChanged: (selected) {
            tempRecipe = tempRecipe.copyWith(tags: selected);
          },
        ),
      }[innerScreen];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            tabController.index = 0;
            unfocus(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () => onDone?.call(tempRecipe), icon: Icon(Icons.done))
        ],
        title: Text('Add/Update'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _displayInnerScreen(),
        ),
      ),
    );
  }
}

class _UpdateGeneralInfoMainTab extends StatelessWidget {
  final Recipe recipe;
  final RecipeScreenStateNotifier notifier;
  final TabController tabController;
  final void Function(_fields)? onTap;

  const _UpdateGeneralInfoMainTab(
      {Key? key,
      required this.recipe,
      required this.notifier,
      required this.tabController,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add/Update'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text("Section"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16,
              ),
              onTap: () async {
                onTap?.call(_fields.section);
                /* final newSection =
                    await showTextDialog(context, recipe.section, 'Section');
                if (newSection != null) {
                  notifier.updateSection(newSection);
                } */
              },
            ),
            ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text("Description"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16,
              ),
              onTap: () async {
                onTap?.call(_fields.description);
                /* final newDesc =
                    await showTextDialog(context, recipe.note, 'Description');
                if (newDesc != null) {
                  notifier.updateDescription(newDesc);
                } */
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_outlined),
              title: Text("Note"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16,
              ),
              onTap: () async {
                onTap?.call(_fields.note);
                /* final newNote =
                    await showTextDialog(context, recipe.note, 'Notes');
                if (newNote != null) {
                  notifier.updateNote(newNote);
                } */
              },
            ),
            ListTile(
                leading: Icon(Icons.shortcut_rounded),
                title: Text("Related recipes"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black26,
                  size: 16,
                ),
                onTap: () async {
                  onTap?.call(_fields.related_recipes);
                  /* final relatedRecipe =
                      await showTextDialog(context, null, 'Related recipe');
                  if (relatedRecipe != null) {
                    notifier.addRelatedRecipes(relatedRecipe);
                  } */
                }),
            ListTile(
              leading: Icon(Icons.local_fire_department_outlined),
              title: Text("Calories"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16,
              ),
            ),
            ListTile(
                leading: Icon(Icons.ondemand_video),
                title: Text("Video"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black26,
                  size: 16,
                ),
                onTap: () async {
                  onTap?.call(_fields.video);
                  /* final newVideoUrl =
                      await showTextDialog(context, null, 'Video');
                  if (newVideoUrl != null) {
                    notifier.updateVideoUrl(newVideoUrl);
                  } */
                }),
            ListTile(
                leading: Icon(Icons.link),
                title: Text("Link"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black26,
                  size: 16,
                ),
                onTap: () async {
                  onTap?.call(_fields.link);
                  /* final newLink = await showTextDialog(context, null, 'Link');
                  if (newLink != null) {
                    notifier.updateRecipeUrl(newLink);
                  } */
                }),
            ListTile(
              leading: Icon(Icons.euro),
              title: Text("Cost"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16,
              ),
            ),
            ListTile(
              leading: Icon(Icons.tag),
              title: Text("Tags"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 16,
              ),
              onTap: () async {
                onTap?.call(_fields.tags);
                /* final newTag = await showTextDialog(context, null, 'Tag');
                if (newTag != null) {
                  notifier.addTag(newTag);
                } */
              },
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  Future<String?> showTextDialog(
      BuildContext context, String? initialText, String title) async {
    final controller = TextEditingController(text: initialText);

    return await showDialog<String?>(
      context: context,
      builder: (context) {
        return BaseDialog(
          title: title,
          children: [
            TextField(
              controller: controller,
            ),
          ],
          onDoneTap: () => Navigator.pop(
            context,
            controller.text.trim(),
          ),
        );
      },
    );
  }
}

class _UpdateTextualValue extends HookConsumerWidget {
  final int? maxLength;
  final String? initialValue;
  final bool multiline;
  final bool autofocus;
  final Icon? textFieldSuffixIcon;

  final void Function(String)? onChanged;

  const _UpdateTextualValue({
    Key? key,
    this.initialValue,
    this.maxLength,
    this.multiline = false,
    this.autofocus = false,
    this.textFieldSuffixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: initialValue);
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLength: maxLength,
      maxLines: multiline ? 10 : 1,
      minLines: 1,
      decoration: InputDecoration(suffixIcon: textFieldSuffixIcon),
      onChanged: (text) {
        onChanged?.call(text);
      },
    );
  }
}

class _MultiValueSelectWithSuggestion<T> extends HookConsumerWidget {
  final bool autofocus;
  final Icon? textFieldSuffixIcon;
  final List<T> currentlySelected;
  final Future<List<T>> Function(String)? suggestionsCallback;
  final void Function(List<T>)? onSelectionChanged;
  late final String Function(T) labelTextSelector;

  _MultiValueSelectWithSuggestion({
    Key? key,
    this.autofocus = true,
    this.textFieldSuffixIcon,
    this.currentlySelected = const [],
    this.suggestionsCallback,
    this.onSelectionChanged,
    String Function(T)? labelTextSelector,
  })  : this.labelTextSelector = labelTextSelector ?? ((T t) => t.toString()),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final suggestions = useState<List<T>>([]);
    final currentlySelectedState = useState(currentlySelected);
    return Column(
      children: [
        TextField(
          controller: controller,
          autofocus: autofocus,
          minLines: 1,
          decoration: InputDecoration(suffixIcon: textFieldSuffixIcon),
          onChanged: (text) {
            suggestionsCallback?.call(text).then((values) {
              suggestions.value = values;
            });
          },
        ),
        ..._buildCurrentlySelectedTiles(
            currentlySelectedState.value, currentlySelectedState),
        SizedBox(height: 10),
        ...suggestions.value
            .where((s) => !currentlySelectedState.value.contains(s))
            .map((s) => _buildSuggestionTile(
                context, s, controller, currentlySelectedState, suggestions))
            .toList()
      ],
    );
  }

  List<Widget> _buildCurrentlySelectedTiles(
      List<T> selected, ValueNotifier<List<T>> selectedNotifier) {
    final ret = selected.map((cs) {
      final label = labelTextSelector(cs);

      return ListTile(
        key: UniqueKey(),
        title: Text(label),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            selectedNotifier.value = [...selectedNotifier.value]
              ..removeWhere((s) => s == cs);

            onSelectionChanged?.call(selectedNotifier.value);
          },
        ),
      );
    }).toList();

    if (ret.isNotEmpty) {
      return [...ret, Divider()];
    }

    return ret;
  }

  Widget _buildSuggestionTile(
      BuildContext context,
      T suggestion,
      TextEditingController controller,
      ValueNotifier<List<T>> selectedNotifier,
      ValueNotifier<List<T>> suggestionNotifier) {
    final label = labelTextSelector(suggestion);
    return ListTile(
      key: UniqueKey(),
      title: Text(label),
      onTap: () {
        selectedNotifier.value = [...selectedNotifier.value, suggestion];
        suggestionNotifier.value = [];
        onSelectionChanged?.call(selectedNotifier.value);
        controller.text = '';
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class _MultiValueTextWithSuggestion<T> extends HookConsumerWidget {
  final bool autofocus;
  final Icon? textFieldSuffixIcon;
  final List<T> currentlySelected;
  final Icon? submitButtonIcon;
  final T Function(String) textToTypeConverter;
  final Future<List<T>> Function(String)? suggestionsCallback;
  final void Function(List<T>)? onSelectionChanged;
  late final String Function(T) labelTextSelector;

  _MultiValueTextWithSuggestion({
    Key? key,
    required this.textToTypeConverter,
    this.autofocus = true,
    this.textFieldSuffixIcon,
    this.currentlySelected = const [],
    this.suggestionsCallback,
    this.onSelectionChanged,
    this.submitButtonIcon,
    String Function(T)? labelTextSelector,
  })  : this.labelTextSelector = labelTextSelector ?? ((T t) => t.toString()),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final suggestions = useState<List<T>>([]);
    final currentlySelectedState = useState(currentlySelected);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: autofocus,
                minLines: 1,
                decoration: InputDecoration(suffixIcon: textFieldSuffixIcon),
                onSubmitted: (text) => _submit(
                  context,
                  textToTypeConverter(text),
                  controller,
                  currentlySelectedState,
                  suggestions,
                ),
                onChanged: (text) {
                  suggestionsCallback?.call(text).then((values) {
                    suggestions.value = values;
                  });
                },
              ),
            ),
            if (submitButtonIcon != null)
              IconButton(
                onPressed: () => _submit(
                    context,
                    textToTypeConverter(controller.text),
                    controller,
                    currentlySelectedState,
                    suggestions),
                icon: submitButtonIcon!,
              )
          ],
        ),
        ..._buildCurrentlySelectedTiles(
            currentlySelectedState.value, currentlySelectedState),
        SizedBox(height: 10),
        ...suggestions.value
            .where((s) => !currentlySelectedState.value.contains(s))
            .map((s) => _buildSuggestionTile(
                context, s, controller, currentlySelectedState, suggestions))
            .toList()
      ],
    );
  }

  void _submit(
      BuildContext context,
      T suggestion,
      TextEditingController controller,
      ValueNotifier<List<T>> selectedNotifier,
      ValueNotifier<List<T>> suggestionNotifier) {
    selectedNotifier.value = [...selectedNotifier.value, suggestion];
    suggestionNotifier.value = [];
    onSelectionChanged?.call(selectedNotifier.value);
    controller.text = '';
    FocusScope.of(context).unfocus();
  }

  List<Widget> _buildCurrentlySelectedTiles(
      List<T> selected, ValueNotifier<List<T>> selectedNotifier) {
    final ret = selected.map((cs) {
      final label = labelTextSelector(cs);

      return ListTile(
        key: UniqueKey(),
        title: Text(label),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            selectedNotifier.value = [...selectedNotifier.value]
              ..removeWhere((s) => s == cs);

            onSelectionChanged?.call(selectedNotifier.value);
          },
        ),
      );
    }).toList();

    if (ret.isNotEmpty) {
      return [...ret, Divider()];
    }

    return ret;
  }

  Widget _buildSuggestionTile(
      BuildContext context,
      T suggestion,
      TextEditingController controller,
      ValueNotifier<List<T>> selectedNotifier,
      ValueNotifier<List<T>> suggestionNotifier) {
    final label = labelTextSelector(suggestion);
    return ListTile(
      key: UniqueKey(),
      title: Text(label),
      onTap: () {
        _submit(
          context,
          suggestion,
          controller,
          selectedNotifier,
          suggestionNotifier,
        );
      },
    );
  }
}
