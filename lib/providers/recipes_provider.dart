import 'package:flutter/material.dart';

import '../models/recipe.dart';

Recipe _insalataAndrea = Recipe(
  id: "adfie82bfiui",
  name: "Insalata Andrea",
  description: "A delicious salad",
  servs: 2,
  rating: 2,
  cost: 1,
  estimatedCookingTime: 0,
  estimatedPreparationTime: 10,
  ingredients: [],
  imgUrl:
      "https://www.cucchiaio.it/content/cucchiaio/it/ricette/2018/08/insalata-con-uova-pane-e-mandorle/jcr:content/header-par/image-single.img10.jpg/1533489383063.jpg",
  tags: ["Vegetarian", "Healty", "Fast"],
);

Recipe _paneeOlio = Recipe(
  id: "fno2ecb22o",
  name: "Pane & Olio",
);

Recipe _vellutataDiCeci = Recipe(
  id: "314rf42e",
  name: "Vellutata di ceci",
);

Recipe _pizza = Recipe(
  id: "24w1r1d13",
  name: "Pizza",
);
Recipe _pizzaCottoEFunghi = Recipe(
  id: "o108vh80924",
  name: "Pizza Cotto & Funghi",
);

class RecipesProvider with ChangeNotifier {
  List<Recipe> _recipes = [_insalataAndrea, _paneeOlio];

  List<Recipe> get getRecipes => [..._recipes];

  Recipe getById(String id) => _recipes.firstWhere((ing) => ing.id == id);
}
