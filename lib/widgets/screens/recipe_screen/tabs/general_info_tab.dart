import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:weekly_menu_app/widgets/screens/recipe_screen/recipe_information_tiles.dart';

import '../../../../models/recipe.dart';
import '../../../shared/editable_text_field.dart';

class RecipeGeneralInfoTab extends StatelessWidget {
  final bool editEnabled;
  final RecipeOriginator originator;

  const RecipeGeneralInfoTab({
    Key? key,
    required this.originator,
    this.editEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = originator.instance;

    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: RecipeInformationTiles(
              originator,
              editEnabled: editEnabled,
            ),
          ),
        ),
      ],
    );
  }
}
