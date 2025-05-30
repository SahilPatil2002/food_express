import 'package:dio/dio.dart';
import 'meal_model.dart';

class MealDbService {
  static final Dio _dio = Dio();

  static Future<List<String>> fetchCategories() async {
    final response = await _dio.get(
      'https://www.themealdb.com/api/json/v1/1/categories.php',
    );
    if (response.statusCode == 200) {
      final data = response.data;
      final List categories = data['categories'];
      return categories.map<String>((e) => e['strCategory'] as String).toList();
    }
    return [];
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await _dio.get(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
    );

    if (response.statusCode == 200 && response.data['meals'] != null) {
      final List meals = response.data['meals'];
      final List<Meal> detailedMeals = await Future.wait(
        meals.map<Future<Meal>>((e) async {
          final id = e['idMeal'];
          final detailResponse = await _dio.get(
            'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id',
          );

          if (detailResponse.statusCode == 200 &&
              detailResponse.data['meals'] != null) {
            return Meal.fromJson(detailResponse.data['meals'][0]);
          }
          return Meal.fromJson(e);
        }),
      );
      return detailedMeals;
    }
    return [];
  }

  static Future<List<Meal>> fetchRandomMeals({int count = 10}) async {
    List<Meal> randomMeals = [];
    for (int i = 0; i < count; i++) {
      final response = await _dio.get(
        'https://www.themealdb.com/api/json/v1/1/random.php',
      );
      if (response.statusCode == 200 && response.data['meals'] != null) {
        final meal = Meal.fromJson(response.data['meals'][0]);
        randomMeals.add(meal);
      }
    }
    return randomMeals;
  }

  static Future<List<Meal>> searchMealsByName(String name) async {
    final response = await _dio.get(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$name',
    );
    if (response.statusCode == 200 && response.data['meals'] != null) {
      return (response.data['meals'] as List)
          .map<Meal>((json) => Meal.fromJson(json))
          .toList();
    }
    return [];
  }
}
