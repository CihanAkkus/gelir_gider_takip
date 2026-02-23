import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';

class SaveButton extends StatelessWidget {
  final TransactionViewModel controller;
  final TextEditingController amountController;
  final TextEditingController descController;

  const SaveButton({
    super.key,
    required this.controller,
    required this.amountController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE5A1AF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
        onPressed: () {

          if (controller.selectedCategory.value == null ||
              amountController.text.isEmpty) {
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
            title: controller.selectedCategory.value!.name,
            description: descController.text,
            amount:
                double.tryParse(amountController.text.replaceAll(',', '.')) ??
                0.0,
            date: controller.selectedDate.value,
            type: controller.isGider.value
                ? TransactionType.gider
                : TransactionType.gelir,
          );

          controller.addTransaction(newTx);

          Get.back();
        },
        child: const Text(
          "Kaydet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
