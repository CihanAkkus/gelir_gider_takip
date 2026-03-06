import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/add_transaction_view.dart';
import 'add_transaction_viewmodel.dart';

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
    await Get.to(
          () => AddTransactionView(),
      binding: BindingsBuilder(() {
        Get.put(AddTransactionViewModel(repository: Get.find()));
      }),
    );//işlem ekleme sayfasına gittiğimde yazılar sıfırlanmış olarak gelsin diye yaptık
  }

}
