import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:get/get.dart';
import '../repositories/transaction_repository.dart';
import '../viewmodels/main_layout_viewmodel.dart';
import '../viewmodels/statistics_viewmodel.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRepository>(() => TransactionRepository());
//yukardaki değeri böyle yaratırsak hep aynı objeyi kullanacağız ama klasik nesne oluşturma ile yapsak
//
    Get.lazyPut<TransactionViewModel>(
      () => TransactionViewModel(repository: Get.find()),
    );//bunu böyle yapma sebebimiz, repository nesne ihityacı oluştuğunda tek bi yerden
    //çağırılsın ki, bi tutarlılık olsun zincir olsun ilerde repository değiştirdiğimde
    //tek tek tüm çağırdığım yerlerde değiştirmek zorunda kalmayayım
    //TransactionViewModel üzerinden oluşturursak hep bi sıkıntı yaşamayız.

    Get.lazyPut<MainLayoutViewModel>(() => MainLayoutViewModel());
    Get.lazyPut<StatisticsViewModel>(() => StatisticsViewModel());

  }
}
