import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_express/controllers/search_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  final MySearchController controller = Get.put(MySearchController());

  final TextEditingController textController = TextEditingController();
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final yellow = Color.fromRGBO(250, 194, 45, 1);

    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 245, 255, 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      searchTextController.clear(); 
                      Get.find<MySearchController>().clearSearchResults();
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(250, 194, 45, 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: yellow),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Search Meals",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                // elevation: 1,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: yellow, width: 1.5),
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, color: yellow),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          cursorColor: yellow,
                          onSubmitted: controller.searchMeals,
                          decoration: InputDecoration(
                            hintText: "Search for delicious meals...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.searchMeals(textController.text);
                        },
                        child: Icon(
                          Icons.search,
                          // size: 16,
                          color: yellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔁 Result Area
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: yellow),
                  );
                }

                if (controller.searchResults.isEmpty) {
                  return Column(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      Text(
                        "No meals found.",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (_, index) {
                    final meal = controller.searchResults[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color.fromRGBO(250, 194, 45, 1),
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(meal.strMealThumb ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meal.strMeal ?? 'Unknown Meal',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: yellow
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        meal.strArea ?? 'Unknown',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: yellow,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
