import 'package:food_express/models/meal_db_service.dart';
import 'package:food_express/models/meal_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <String>[].obs;
  var meals = <Meal>[].obs;
  var isCategoryLoading = true.obs;
  var isMealLoading = false.obs;
  var selectedCategory = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    isCategoryLoading.value = true;
    final fetched = await MealDbService.fetchCategories();
    categories.value = ['All', ...fetched];
    selectedCategory.value = 'All';
    isCategoryLoading.value = false;
    loadMealsByCategory('All');
  }

  void loadMealsByCategory(String category) async {
  // Set the selected category and let the UI rebuild
  selectedCategory.value = category;

  // Load meals after ensuring UI updates
  await Future.delayed(Duration(milliseconds: 10));

  isMealLoading.value = true;

  if (category == 'All') {
    meals.value = await MealDbService.fetchRandomMeals(count: 10);
  } else {
    meals.value = await MealDbService.fetchMealsByCategory(category);
  }

  isMealLoading.value = false;
}

}
