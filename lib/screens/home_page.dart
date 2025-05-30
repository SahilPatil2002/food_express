import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_express/controllers/category_controller.dart';
import 'package:food_express/screens/search_screen.dart';
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
      // appBar: AppBar(
      //   systemOverlayStyle: SystemUiOverlayStyle.dark,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: Icon(Icons.menu, color: Colors.black),
      //   centerTitle: true,
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.all(10.0),
      //       child: CircleAvatar(
      //         backgroundImage: NetworkImage(
      //           'https://e7.pngegg.com/pngimages/348/800/png-clipart-man-wearing-blue-shirt-illustration-computer-icons-avatar-user-login-avatar-blue-child-thumbnail.png',
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
                // Only show loader during initial category fetch
                if (controller.isCategoryLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Color(0xFFfac22d)),
                  );
                }

                // If no categories found
                if (controller.categories.isEmpty) {
                  return Center(child: Text("No categories found."));
                }

                // Show category bar
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
                        color: Color(0xFFfac22d),
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

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Fixed image section
                            Center(
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFFfac22d),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFfac22d),
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 8),
                            SizedBox(
                              height: 40,
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(height: 5),

                            // Category/Area Tags
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              children: [
                                // _buildTag(category, Icons.local_dining),
                                _buildTag(area, Icons.location_on),
                              ],
                            ),

                            SizedBox(height: 6),

                            // Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (_) => Icon(
                                  Icons.star,
                                  color: Color(0xFFfac22d),
                                  size: 16,
                                ),
                              ),
                            ),

                            Spacer(),

                            // Price and Add Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "\$${(10 + index * 2)}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFfac22d),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Add to cart logic
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFfac22d),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
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
        Icon(icon, size: 12, color: Color(0xFFfac22d)),
        SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.black),
        ),
      ],
    ),
  );
}
