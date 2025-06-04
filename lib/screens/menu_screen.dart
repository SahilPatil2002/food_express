import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_express/widgets/meal_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_express/controllers/menu_controller.dart';
import 'package:food_express/models/meal_model.dart';
import 'package:food_express/models/meal_db_service.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyMenuController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Favorite Meals 🍔',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 250, 194, 45),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 250, 194, 45)),
      ),
      body: Obx(() {
        if (controller.isMealLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 250, 194, 45),
            ),
          );
        }

        if (controller.meals.isEmpty) {
          return Center(child: Text("No meals found."));
        }

        return Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8, bottom: 8),
          child: GridView.builder(
            itemCount: controller.meals.length,
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (_, index) {
              final item = controller.meals[index];
              final imageUrl = item.strMealThumb ?? '';
              final title = item.strMeal ?? 'Unknown Meal';
              final category = item.strCategory ?? 'Unknown';
              final area = item.strArea ?? 'Unknown';
          
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(158, 158, 158, 0.5),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MealCard(meal: item, index: index),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
