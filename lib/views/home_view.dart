import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/mock_data/mock_data.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:gelir_gider_takip/views/add_transaction_view.dart';
import 'package:gelir_gider_takip/widgets/filter_bottom_sheet.dart';
import 'package:gelir_gider_takip/widgets/summary_card.dart';
import 'package:gelir_gider_takip/widgets/transaction_item.dart';
import 'package:get/get.dart';

import '../widgets/search_text_field.dart';

class HomeView extends GetView<TransactionViewModel> {
  HomeView({
    super.key,
  }); //const olamaz çünkü İçindeki tüm field’lar da compile-time sabit olmalı.


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gelir Gider App"),
        actions: [
          IconButton(
            onPressed: () async {
              await runMockData();
              controller.getTransactions();
            },
            icon: const Icon(Icons.downloading),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "Toplam Gelir",
                    amount: Obx(
                      () => Text(
                        "₺ ${controller.totalIncome.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    color: const Color(0xFF8DBEAD),
                    icon: Icons.arrow_upward,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: "Toplam Gider",
                    amount: Obx(
                      () => Text(
                        "₺ ${controller.totalExpense.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    color: const Color(0xFFE5A1AF),
                    icon: Icons.arrow_downward,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SearchTextField(
                  queryChanged: controller.searchTransactions,
                  controller: controller.queryController,
                  hint: 'Arama',
                  icon: Icons.search,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      FilterBottomSheet(),
                      isScrollControlled: true,
                    );
                  },
                  icon: const Icon(Icons.tune, color: const Color(0xFF8DBEAD)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Obx(() {
                if (controller.filteredTransactions.isEmpty) {
                  return const Center(
                    child: Text(
                      "İşlem bulunamadı",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.filteredTransactions[index];
                    return TransactionItem(
                      item: transaction,
                      controller: controller,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.selectedDate.value = DateTime.now();
          await Get.to(() => AddTransactionView());
          controller.queryController.clear();
          controller.clearSearch();
        },
        backgroundColor: const Color(0xFFE5A1AF),
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color(0xFF8DBEAD),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.grid_view, color: Colors.white),
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
