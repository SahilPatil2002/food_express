import 'package:food_express/models/meal_db_service.dart';
import 'package:food_express/models/meal_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <String>[].obs;
  var meals = <Meal>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    isLoading.value = true;
    categories.value = await MealDbService().fetchCategories();
    isLoading.value = false;
  }

  void loadMealsByCategory(String category) async {
  isLoading.value = true;
  meals.value = await MealDbService().fetchMealsByCategory(category);
  print("🍽 Loaded meals for $category: ${meals.length}"); // Add this line
  isLoading.value = false;
}

}
