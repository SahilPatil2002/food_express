import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_express/screens/product_detail_screen.dart';
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
                    // border: Border.all(color: yellow, width: 1.5),
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Icon(Icons.restaurant, color: yellow),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          cursorColor: yellow,
                          onSubmitted: controller.searchMeals,
                          decoration: InputDecoration(
                            hintText: "Search for delicious meals...",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.searchMeals(textController.text);
                        },
                        child: Icon(Icons.search, size: 30, color: yellow),
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
                    final imageUrl = meal.strMealThumb ?? '';
                    return InkWell(
                      onTap: (){
                        Get.to(() => ProductDetailScreen(meal: meal));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                               Color.fromRGBO(0, 0, 0, 0.3),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Container(
                                  color:  Color.fromRGBO(0, 0, 0, 0.7),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
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
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            meal.strMeal ?? 'Unknown Meal',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                meal.strArea ?? 'Unknown Area',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(255, 244, 206, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.fastfood,
                                                      size: 12,
                                                      color: Color.fromRGBO(
                                                        250,
                                                        194,
                                                        45,
                                                        1,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      meal.strCategory ??
                                                          'Category',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
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
                                      color: Color.fromRGBO(250, 194, 45, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
