import 'package:gelir_gider_takip/controllers/transaction_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionController());
  }


}