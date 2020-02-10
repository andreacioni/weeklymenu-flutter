import 'package:weekly_menu_app/models/unit_of_measure.dart';

import './models/recipe.dart';
import './models/menu.dart';
import './models/meals.dart';
import './models/ingredient.dart';

var ingInsalata = RecipeIngredient(
    name: "Insalata", quantity: 50, unitOfMeasure: unitsOfMeasure[0]);
var ingPomodori = RecipeIngredient(
    name: "Pomodori", quantity: 1, unitOfMeasure: unitsOfMeasure[0]);
var ingTonno = RecipeIngredient(
    name: "Tonno", quantity: 50, unitOfMeasure: unitsOfMeasure[2]);

List<Ingredient> DUMMY_INGREDIENTS = <Ingredient>[
  ingInsalata,
  ingPomodori,
  ingTonno,
];

Recipe insalataAndrea = Recipe(
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

Recipe paneeOlio = Recipe(
  id: "fno2ecb22o",
  name: "Pane & Olio",
);

final List<Recipe> DUMMY_RECIPES = [insalataAndrea, paneeOlio];

final List<UnitOfMeasure> unitsOfMeasure = [
  UnitOfMeasure("1", "pcs"),
  UnitOfMeasure("2", "gr"),
  UnitOfMeasure("3", "cl"),
];

List<Menu> DUMMY_MENUS = [
  Menu(day: DateTime(2020, 01, 14), meals: {
    Meal.Lunch: [
      insalataAndrea,
    ],
  }),
  Menu(day: DateTime(2020, 01, 15), meals: {
    Meal.Lunch: [
      insalataAndrea,
      paneeOlio,
      Recipe(
        name: "Vellutata di ceci",
      )
    ],
    Meal.Dinner: [
      Recipe(
        name: "Pizza",
      ),
      Recipe(
        name: "Pizza Cotto & Funghi",
      ),
    ],
  }),
  Menu(day: DateTime(2020, 01, 16), meals: {
    Meal.Lunch: [insalataAndrea, paneeOlio],
  }),
];
