import './models/recipe.dart';
import './models/menu.dart';
import './models/meals.dart';
import './models/ingredient.dart';

Recipe insalataAndrea = Recipe(
        name: "Insalata Andrea",
        description: "A delicious salad",
        servs: 2,
        rating: 2,
        cost: 1,
        estimatedCookingTime: 0,
        estimatedPreparationTime: 10,
        ingredients: [
          RecipeIngredient(
              name: "Insalata", quantity: 50, unitOfMeasure: "pcs"),
          RecipeIngredient(name: "Pomodori", quantity: 1, unitOfMeasure: "pcs"),
          RecipeIngredient(name: "Tonno", quantity: 50, unitOfMeasure: "gr")
        ],
        imgUrl:
            "https://www.cucchiaio.it/content/cucchiaio/it/ricette/2018/08/insalata-con-uova-pane-e-mandorle/jcr:content/header-par/image-single.img10.jpg/1533489383063.jpg",
        tags: ["Vegetarian", "Healty", "Fast"],
      );

List<Menu> DUMMY_MENUS = [
  Menu(day: DateTime(2020, 01, 14), meals: {
    Meal.Lunch: [
      insalataAndrea,
    ],
  }),
  Menu(day: DateTime(2020, 01, 15), meals: {
    Meal.Lunch: [
      insalataAndrea,
      Recipe(
        name: "Pane & Olio",
      ),
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
    Meal.Lunch: [
      insalataAndrea,
      Recipe(
        name: "Pane & Olio",
      )
    ],
  }),
];
