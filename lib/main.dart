import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_express/controllers/navigation_controller.dart';
import 'package:food_express/models/theme.dart';
import 'package:food_express/screens/home_page.dart';
import 'package:get/get.dart';
import 'package:food_express/screens/menu_screen.dart';
import 'package:food_express/screens/order_screen.dart';
import 'package:food_express/screens/profile_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NavigationController navController = Get.put(NavigationController());
  final List<Widget> _pages = [
    HomeScreen(),
    MenuScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _pages[navController.selectedIndex.value],
          bottomNavigationBar: CurvedNavigationBar(
            index: navController.selectedIndex.value,
            height: 60,
            color: Color(0xFFfac22d),
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 300),
            onTap: navController.changePage,
            items: const <Widget>[
              Icon(Icons.home, size: 30, color: Colors.white),
              Icon(Icons.fastfood_outlined, size: 30, color: Colors.white),
              Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.white),
              Icon(Icons.person_outline, size: 30, color: Colors.white),
            ],
          ),
        ));
  }
}
