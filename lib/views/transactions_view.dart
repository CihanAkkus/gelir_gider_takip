import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../mock_data/mock_data.dart';
import '../viewmodels/transaction_viewmodel.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_item.dart';
import '../widgets/search_text_field.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final controller = Get.find<TransactionViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Gelir Gider App"),
        actions: [
          IconButton(
            onPressed: () async {
              await runMockData();
              controller.getCategories();//mockdata için
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
                    color: AppColors.incomeGreen,
                    icon: Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 12),
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
                    color: AppColors.expenseRed,
                    icon: Icons.arrow_downward,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                  icon: const Icon(Icons.tune, color: AppColors.incomeGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                  if (controller.isLoadingMore.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.incomeGreen,
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      "İşlem bulunamadı",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: controller.transactions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.transactions.length) {
                      return Obx(() {
                        if (controller.isLoadingMore.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.incomeGreen,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      });
                    }
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
    );
  }
}
