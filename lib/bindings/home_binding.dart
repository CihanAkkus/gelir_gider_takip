import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:get/get.dart';

import '../repositories/transaction_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRepository>(() => TransactionRepository());

    Get.lazyPut<TransactionViewModel>(
      () => TransactionViewModel(repository: Get.find()),
    );
  }
}
