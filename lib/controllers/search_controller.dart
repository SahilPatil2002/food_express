import 'package:food_express/models/meal_db_service.dart';
import 'package:food_express/models/meal_model.dart';
import 'package:get/get.dart';

class MySearchController extends GetxController {
  var searchQuery = ''.obs;
  var searchResults = <Meal>[].obs;
  var isLoading = false.obs;

  void searchMeals(String query) async {
    if (query.trim().isEmpty) return;

    searchQuery.value = query;
    isLoading.value = true;

    try {
      final results = await MealDbService.searchMealsByName(query);
      searchResults.assignAll(results);
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearchResults() {
    searchResults.clear(); // assuming searchResults is an RxList
    update(); // or use .refresh() if you're using RxList
  }
}
