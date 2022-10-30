import 'package:flutter/material.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:weekly_menu_app/widgets/screens/recipe_screen/recipe_screen_state_notifier.dart';

import '../../../models/recipe.dart';
import '../../shared/base_dialog.dart';

class UpdateGeneralInfoRecipeBottomSheet extends StatefulWidget {
  final Recipe recipe;
  final RecipeScreenStateNotifier notifier;

  const UpdateGeneralInfoRecipeBottomSheet(
      {Key? key, required this.recipe, required this.notifier})
      : super(key: key);

  @override
  State<UpdateGeneralInfoRecipeBottomSheet> createState() =>
      _UpdateGeneralInfoRecipeBottomSheetState();
}

class _UpdateGeneralInfoRecipeBottomSheetState
    extends State<UpdateGeneralInfoRecipeBottomSheet>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tabs = [
      _UpdateGeneralInfoMainTab(
        recipe: widget.recipe,
        notifier: widget.notifier,
        tabController: _tabController,
      ),
      _UpdateSpecificFieldTab(
        recipe: widget.recipe,
        notifier: widget.notifier,
        tabController: _tabController,
      )
    ];

    return DefaultTabController(
      length: tabs.length,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: tabs,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _UpdateSpecificFieldTab extends StatelessWidget {
  final Recipe recipe;
  final RecipeScreenStateNotifier notifier;
  final TabController tabController;

  const _UpdateSpecificFieldTab(
      {Key? key,
      required this.recipe,
      required this.notifier,
      required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => tabController.index = 0,
        ),
        title: Text('Add/Update'),
        elevation: 0,
      ),
      body: Center(child: Text('Prova')),
    );
  }
}

class _UpdateGeneralInfoMainTab extends StatelessWidget {
  final Recipe recipe;
  final RecipeScreenStateNotifier notifier;
  final TabController tabController;

  const _UpdateGeneralInfoMainTab(
      {Key? key,
      required this.recipe,
      required this.notifier,
      required this.tabController})
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
                tabController.index = 1;
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
                final newDesc =
                    await showTextDialog(context, recipe.note, 'Description');
                if (newDesc != null) {
                  notifier.updateDescription(newDesc);
                }
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
                final newNote =
                    await showTextDialog(context, recipe.note, 'Notes');
                if (newNote != null) {
                  notifier.updateNote(newNote);
                }
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
                  final relatedRecipe =
                      await showTextDialog(context, null, 'Related recipe');
                  if (relatedRecipe != null) {
                    notifier.addRelatedRecipes(relatedRecipe);
                  }
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
                  final newVideoUrl =
                      await showTextDialog(context, null, 'Video');
                  if (newVideoUrl != null) {
                    notifier.updateVideoUrl(newVideoUrl);
                  }
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
                  final newLink = await showTextDialog(context, null, 'Link');
                  if (newLink != null) {
                    notifier.updateRecipeUrl(newLink);
                  }
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
                final newTag = await showTextDialog(context, null, 'Tag');
                if (newTag != null) {
                  notifier.addTag(newTag);
                }
              },
            ),
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
              onDoneTap: () => Navigator.pop(context, controller.text.trim()));
        });
  }
}
