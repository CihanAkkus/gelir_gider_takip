import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/bindings/home_binding.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/views/home_view.dart';
import 'package:gelir_gider_takip/services/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DbHelper.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gelir Gider App",
      initialBinding: HomeBinding(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF8DBEAD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8DBEAD),
          elevation: 0,
        ),
      ),
      home: const HomeView(),
    );
  }
}