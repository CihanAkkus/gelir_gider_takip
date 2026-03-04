import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/constants/app_colors.dart';
import '../viewmodels/add_transaction_viewmodel.dart';

class SaveButton extends StatelessWidget {
  final AddTransactionViewModel controller;

  const SaveButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
        onPressed: () {
          controller.saveTransaction();
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
