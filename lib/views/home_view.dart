import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:gelir_gider_takip/views/add_transaction_view.dart';
import 'package:gelir_gider_takip/widgets/summary_card.dart';
import 'package:gelir_gider_takip/widgets/transaction_item.dart';
import 'package:get/get.dart';

class HomeView extends GetView<TransactionViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gelir Gider App"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "Aylık Gelir",
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
                    title: "Aylık Gider",
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
          SizedBox(height: 20),
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
                if (controller.transactions.isEmpty) {
                  return const Center(
                    child: Text(
                      "Henüz bir işlem eklenmedi",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.transactions[index];
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
        onPressed: () => Get.to(() => AddTransactionView()),
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
