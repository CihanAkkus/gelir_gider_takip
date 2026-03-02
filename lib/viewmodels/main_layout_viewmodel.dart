import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:get/get.dart';

import '../views/add_transaction_view.dart';

class MainLayoutViewModel extends GetxController {
  late PageController pageController;

  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit(); //ilk satıra yazmak iyidir önce gerekli şeyler başlar
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose(); //son satıra yazmak iyidir en son gerekli şeyler kapanır
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }//kullanıcı kaydırınca aktif sayfanın indexi parametre olarak buraya geliyor

  Future<void> navigateToAddTransaction() async {
    final txController = Get.find<TransactionViewModel>();

    txController.selectedDate.value = DateTime.now();

    await Get.to(() => AddTransactionView());
  }
}
