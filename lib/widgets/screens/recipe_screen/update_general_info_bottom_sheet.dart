import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'recipe_screen_state_notifier.dart';
import '../../../models/recipe.dart';
import '../../shared/base_dialog.dart';

final _stateProvider = StateProvider<_fields?>((_) => null);

enum _fields {
  section,
  description,
  note,
  related_recipes,
  calories,
  video,
  link,
  cost,
  tags
}

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

    return DefaultTabController(
      length: tabs.length,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: tabs,
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

    var recipes = <Recipe>[];
    ref
        .read(recipesRepositoryProvider)
        .findAll(remote: false)
        .then((value) => recipes = value ?? <Recipe>[]);

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
        _fields.related_recipes: _MultiValueSelectWithSuggestion(
          key: ValueKey(_fields.related_recipes),
          textFieldSuffixIcon: Icon(Icons.search_outlined),
          suggestionsCallback: (text) async {
            if (text.trim().isEmpty) {
              return const [];
            }
            return recipes
                .where((r) => r.name.toLowerCase().contains(text.toLowerCase()))
                .where((r) =>
                    tempRecipe.relatedRecipes
                        .firstWhereOrNull((rr) => r.id == rr.id) ==
                    null)
                .map((r) => r.name)
                .toList();
          },
          onChanged: (text) =>
              tempRecipe = tempRecipe.copyWith(note: text.trim()),
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
      }[innerScreen];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => tabController.index = 0,
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
        backgroundColor: theme.backgroundColor,
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

class _MultiValueSelectWithSuggestion extends HookConsumerWidget {
  final bool autofocus;
  final Icon? textFieldSuffixIcon;
  final List<String> currentlySelected;
  final Future<List<String>> Function(String)? suggestionsCallback;

  final void Function(String)? onChanged;

  const _MultiValueSelectWithSuggestion({
    Key? key,
    this.autofocus = true,
    this.textFieldSuffixIcon,
    this.onChanged,
    this.currentlySelected = const [],
    this.suggestionsCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final suggestions = useState<List<String>>([]);
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

            onChanged?.call(text);
          },
        ),
        ..._buildCurrentlySelectedTiles(currentlySelectedState.value),
        SizedBox(height: 10),
        ...suggestions.value
            .where((s) => !currentlySelectedState.value.contains(s))
            .map((s) => _buildSuggestionTile(
                context, s, controller, currentlySelectedState, suggestions))
            .toList()
      ],
    );
  }

  List<Widget> _buildCurrentlySelectedTiles(List<String> selected) {
    final ret = selected
        .map((cs) => ListTile(
              key: ValueKey(cs),
              title: Text(cs),
              trailing: Icon(Icons.done),
            ))
        .toList();

    if (ret.isNotEmpty) {
      return [...ret, Divider()];
    }

    return ret;
  }

  Widget _buildSuggestionTile(
      BuildContext context,
      String suggestion,
      TextEditingController controller,
      ValueNotifier<List<String>> selectedNotifier,
      ValueNotifier<List<String>> suggestionNotifier) {
    return ListTile(
      key: ValueKey(suggestion),
      title: Text(suggestion),
      onTap: () {
        selectedNotifier.value = [...selectedNotifier.value, suggestion];
        suggestionNotifier.value = [];
        controller.text = '';
        FocusScope.of(context).unfocus();
      },
    );
  }
}
