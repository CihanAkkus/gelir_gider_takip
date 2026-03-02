import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/viewmodels/main_layout_viewmodel.dart';
import 'package:gelir_gider_takip/views/transactions_view.dart';
import 'package:get/get.dart';

class MainLayoutView extends GetView<MainLayoutViewModel> {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // Gövdeyi PageView ile sarıyoruz. Yatay swipe yeteneğini bu sağlıyor.
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const BouncingScrollPhysics(), //scroll efekti
        children: const [
          TransactionsView(),
          Center(
            child: Text(
              "2. Sayfa: İstatistikler ve Grafikler",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigateToAddTransaction(),
        backgroundColor: const Color(0xFFE5A1AF),
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: Obx(() {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: const Color(0xFF8DBEAD),
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => controller.changePage(0),
                  icon: Icon(
                    Icons.grid_view,
                    color: controller.currentIndex.value == 0
                        ? Colors.white
                        : Colors.white54,
                  ),
                ),
                const SizedBox(width: 40),
                IconButton(
                  onPressed: () => controller.changePage(1),
                  icon: Icon(
                    Icons.bar_chart_rounded,
                    color: controller.currentIndex.value == 1
                        ? Colors.white
                        : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
