import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';

import '../constants/app_colors.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel item;
  final TransactionViewModel controller;

  const TransactionItem({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          item.type == TransactionType.gelir
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          color: item.type == TransactionType.gelir
              ? AppColors.incomeGreen
              : AppColors.expenseRed,
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
                  color: Colors.white,
                  /*item.type == TransactionType.gelir
                      ? AppColors.incomeGreen
                      : AppColors.expenseRed,*/
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
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Sil",
                middleText: "Bu işlemi silmek istediğinize emin misiniz?",
                textConfirm: "Evet",
                textCancel: "Hayır",
                confirmTextColor: Colors.white,
                buttonColor: AppColors.expenseRed,
                cancelTextColor: AppColors.expenseRed,
                onConfirm: () {
                  controller.deleteTransaction(item.id);
                  Navigator.pop(
                    context,
                  ); //Getx üst üste ekranlar açıldığı için sil butonuna basınca kafası karışıyor
                  //Get.back();
                },
              );
            },
            icon: const Icon(Icons.delete_outline),
            color: AppColors.expenseRed,
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}
