import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import 'transaction_viewmodel.dart';

class AddTransactionViewModel extends GetxController {
  final TransactionRepository repository;

  AddTransactionViewModel({required this.repository});

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  var isGider = true.obs;
  var selectedDate = DateTime.now().obs;
  var selectedCategory = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    final txController = Get.find<TransactionViewModel>();
    if (txController.categories.isNotEmpty) {
      selectedCategory.value = txController.categories.first;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descController.dispose();
    super.onClose();
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> saveTransaction() async {
    if (selectedCategory.value == null || amountController.text.isEmpty) {
      Get.snackbar(
        "Uyarı",
        "Lütfen kategori seçin ve miktar alanını doldurun!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final newTx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: selectedCategory.value!.id,
      title: selectedCategory.value!.name,
      description: descController.text,
      amount:
          double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0,
      date: selectedDate.value,
      type: isGider.value ? TransactionType.gider : TransactionType.gelir,
    );

    await repository.addTransaction(newTx);

    final txController = Get.find<TransactionViewModel>();
    txController.getTransactions();

    Get.back();

    Get.snackbar(
      "Başarılı",
      "İşlem başarıyla eklendi",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
