import 'package:flutter/material.dart';
import 'package:food_express/models/theme.dart';
import 'package:food_express/screens/home_page.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:convert';

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
      home: HomeScreen(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Express", ),
      ),
      body: Center(
        child: Text(
          'Food Express',
        ),
      ),
    );
  }
}
