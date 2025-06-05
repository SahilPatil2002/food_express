import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_express/controllers/category_controller.dart';
import 'package:food_express/screens/search_screen.dart';
import 'package:food_express/widgets/meal_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(247, 245, 255, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order Fresh &\nTasty Food Now! 🔥",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(_createRouteToSearch());
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 250, 194, 45),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Search meals...",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 194, 45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  "Categories",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isCategoryLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Color.fromRGBO(250, 194, 45, 1)),
                  );
                }
                if (controller.categories.isEmpty) {
                  return Center(child: Text("No categories found."));
                }
                return SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (_, index) {
                      final cat = controller.categories[index];
                      final isSelected =
                          controller.selectedCategory.value == cat;

                      return Obx(() {
                        final isSelected =
                            controller.selectedCategory.value == cat;

                        return GestureDetector(
                          onTap: () {
                            if (!isSelected) {
                              controller.loadMealsByCategory(cat);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Color.fromRGBO(250, 194, 45, 1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.transparent
                                        : Colors.grey[300]!,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                );
              }),

              SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.isMealLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(250, 194, 45, 1),
                      ),
                    );
                  }

                  if (controller.meals.isEmpty) {
                    return Center(child: Text("No meals found."));
                  }

                  return GridView.builder(
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

                      return MealCard(meal: item, index: index);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRouteToSearch() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 900),
    pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0); 
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

}

Widget _buildTag(String label, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Color(0xFFfff4ce),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Color.fromRGBO(250, 194, 45, 1)),
        SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.black),
        ),
      ],
    ),
  );
}
