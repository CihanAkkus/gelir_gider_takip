import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/controllers/transaction_controller.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/features/add_transaction_view.dart';
import 'package:get/get.dart';

class HomeView extends GetView<TransactionController> {
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
                  child: _buildSummaryCard(
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
                  child: _buildSummaryCard(
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
                  return const Text("Henüz bir işlem eklenmedi");
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.transactions[index];
                    return _buildTransactionItem(transaction, controller);
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
          height: 240,
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

Widget _buildTransactionItem(
  TransactionModel item,
  TransactionController controller,
) {
  return ListTile(
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        item.type == TransactionType.gelir
            ? Icons.wallet
            : Icons.directions_bus,
        color: item.type == TransactionType.gelir
            ? const Color(0xFF8DBEAD)
            : const Color(0xFFE5A1AF),
      ),
    ),
    title: Text(
      item.title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(item.description),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${item.type == TransactionType.gelir ? '+' : '-'} ₺ ${item.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: item.type == TransactionType.gelir
                    ? const Color(0xFF8DBEAD)
                    : const Color(0xFFE5A1AF),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "${item.date.day}/${item.date.month}/${item.date.year}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 8),
        IconButton(
          onPressed: () {
            Get.defaultDialog(
              title: "Sil",
              middleText: "Bu işlemi silmek istediğinize emin misiniz?",
              textConfirm: "Evet",
              textCancel: "Hayır",
              confirmTextColor: Colors.white,
              onConfirm: () {
                controller.deleteTransaction(item.id);
                Get.back();
              },
            );
          },
          icon: const Icon(Icons.delete_outline),
          color: Colors.redAccent,
          iconSize: 20,
        ),
      ],
    ),
  );
}

Widget _buildSummaryCard({
  required String title,
  required Widget amount,
  required Color color,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: 8),
        amount,
      ],
    ),
  );
}
