import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weekly_menu_app/providers/recipes_provider.dart';

class TagsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> tags =
        Provider.of<RecipesProvider>(context).getAllRecipeTags;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        itemBuilder: (bCtx, index) {
          return Column(
            children: [
              ListTile(
                title: Text(tags[index]),
              ),
              Divider(
                height: 0,
              ),
            ],
          );
        },
        itemCount: tags.length,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Tags'),
    );
  }
}
