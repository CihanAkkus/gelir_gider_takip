import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/bindings/home_binding.dart';
import 'package:gelir_gider_takip/views/main_layout_view.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/services/db_helper.dart';
import 'constants/app_colors.dart';

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
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.accentBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          scrolledUnderElevation: 0.0,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: MainLayoutView(),
    );
  }
}
