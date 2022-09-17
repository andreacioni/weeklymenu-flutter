import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/recipe.dart';

class RecipeAppBar extends StatelessWidget {
  final bool editModeEnabled;
  final RecipeOriginator _recipe;
  final Object heroTag;
  final Function(bool) onRecipeEditEnabled;
  final void Function() onBackPressed;

  RecipeAppBar(
    this._recipe, {
    this.heroTag = const Object(),
    this.editModeEnabled = false,
    required this.onRecipeEditEnabled,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
      expandedHeight: _recipe.instance.imgUrl != null ? 200.0 : null,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.4),
                ),
                padding: EdgeInsets.all(3),
                child: Text(
                  _recipe.instance.name,
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
        background: _recipe.instance.imgUrl != null
            ? Hero(
                tag: heroTag,
                child: Image(
                  image: CachedNetworkImageProvider(_recipe.instance.imgUrl!),
                  fit: BoxFit.fitWidth,
                ),
              )
            : null,
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

  void _showUpdateImageDialog(BuildContext context) async {
    final textController = TextEditingController();
    if (_recipe.instance.imgUrl != null) {
      textController.text = _recipe.instance.imgUrl!;
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
      _recipe.update(_recipe.instance.copyWith(imgUrl: newUrl));
    }
  }

  void _openEditRecipeNameModal(BuildContext context) async {
    final textController = TextEditingController(text: _recipe.instance.name);
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
      _recipe.update(_recipe.instance.copyWith(name: newRecipeName));
    }
  }
}
