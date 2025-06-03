import 'package:food_express/models/meal_db_service.dart';
import 'package:food_express/models/meal_model.dart';
import 'package:get/get.dart';

class MyMenuController extends GetxController {
  var meals = <Meal>[].obs;
  var isMealLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMeals();
  }

  void fetchAllMeals() async {
    try {
      isMealLoading(true);
      final fetchedMeals = await MealDbService.fetchAllMeals(); 
      meals.assignAll(fetchedMeals);
    } finally {
      isMealLoading(false);
    }
  }
}