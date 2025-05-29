import 'package:dio/dio.dart';
import 'meal_model.dart';

class MealDbService {
  final Dio _dio = Dio();

  Future<List<String>> fetchCategories() async {
    final response = await _dio.get('https://www.themealdb.com/api/json/v1/1/categories.php');
    final data = response.data;
    if (data != null && data['categories'] != null) {
      final List categories = data['categories'];
      return categories.map<String>((e) => e['strCategory'] as String).toList();
    }
    return [];
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
  final response = await _dio.get(
    'https://www.themealdb.com/api/json/v1/1/filter.php',
    queryParameters: {'c': category},
  );
  final data = response.data;
  if (data != null && data['meals'] != null) {
    final List mealsJson = data['meals'];
    return mealsJson.map<Meal>((json) => Meal.fromJson(json)).toList();
  } else {
    print("❌ No meals found for category: $category"); // Add this debug line
    return [];
  }
}

}
