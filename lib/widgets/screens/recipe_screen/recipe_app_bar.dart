import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/recipe.dart';
import '../../../providers/screen_notifier.dart';
import 'screen.dart';

class RecipeAppBar extends HookConsumerWidget {
  final bool editModeEnabled;
  final Function(bool) onRecipeEditEnabled;
  final void Function() onBackPressed;

  RecipeAppBar({
    this.editModeEnabled = false,
    required this.onRecipeEditEnabled,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeScreenNotifierProvider.notifier);

    final recipeName = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.name));

    final imageUrl = ref.watch(recipeScreenNotifierProvider
        .select((n) => n.recipeOriginator.instance.imgUrl));

    void _showUpdateImageDialog(BuildContext context) async {
      final textController = TextEditingController();
      if (imageUrl != null) {
        textController.text = imageUrl;
      }

      String? newUrl = await showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Image URL'),
                content: TextField(
                  decoration: InputDecoration(hintText: 'URL'),
                  controller: textController,
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CANCEL')),
                  FlatButton(
                      onPressed: () =>
                          Navigator.of(context).pop(textController.text),
                      child: Text('OK'))
                ],
              ));

      if (newUrl != null) {
        notifier.updateImageUrl(newUrl);
      }
    }

    void _openEditRecipeNameModal(BuildContext context) async {
      final textController = TextEditingController(text: recipeName);
      String? newRecipeName = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Recipe name'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('CHANGE'),
              onPressed: () {
                var text = textController.text.trim();
                if (text.isNotEmpty) {
                  Navigator.of(context).pop(text);
                }
              },
            )
          ],
        ),
      );

      if (newRecipeName != null) {
        notifier.updateRecipeName(newRecipeName);
      }
    }

    return SliverAppBar(
      //expandedHeight: _recipe.instance.imgUrl != null ? 200.0 : null,
      pinned: true,
      floating: false,
      forceElevated: false,
      scrolledUnderElevation: 2,
      title: Row(
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.4),
              ),
              padding: EdgeInsets.all(3),
              child: AutoSizeText(
                recipeName,
                maxLines: 1,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: SizedBox(
              width: 10,
            ),
          ),
          if (editModeEnabled)
            Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  Icons.edit,
                ),
                onTap: () => _openEditRecipeNameModal(context),
              ),
            )
        ],
      ),

      leading:
          IconButton(icon: Icon(Icons.arrow_back), onPressed: onBackPressed),
      actions: <Widget>[
        if (!editModeEnabled)
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onRecipeEditEnabled(!editModeEnabled),
          ),
        if (editModeEnabled)
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _showUpdateImageDialog(context),
          ),
        if (editModeEnabled)
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () => onRecipeEditEnabled(!editModeEnabled)),
      ],
    );
  }
}
