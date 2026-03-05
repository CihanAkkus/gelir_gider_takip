import 'package:fl_chart/fl_chart.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:get/get.dart';

class StatisticsViewModel extends GetxController {
  var selectedTimeFilter = 'Week'.obs;

  final List<String> timeFilters = ['Day', 'Week', 'Month', 'Year'];

  final RxList<FlSpot> incomeSpots = <FlSpot>[].obs;
  final RxList<FlSpot> expenseSpots = <FlSpot>[].obs;

  var showIncome = true.obs;
  var showExpense = true.obs;

  @override
  void onInit() {
    super.onInit();
    generateChartData();
  }

  Future<void> generateChartData() async {
    final repository = Get.find<TransactionViewModel>().repository;
    //yukarda binding sınıfı içerisinde biz zaten TransactionViewModel constructor'ına
    //parametresini gönderiyoruz burada sadece ona yeni referans ile ulaşıyoruz
    //herkes aynı controller'a ulaşıyor yani get.put özelinde böyle bu
    //get.create olsaydı böyle 1 tane obje olmayacaktı sadece

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var startOfWeek = today.subtract(
      Duration(days: DateTime.now().weekday - 1),
    );

    List<FlSpot> tempIncome = List.generate(
      7,
      (index) => FlSpot(index.toDouble(), 0.0),
    );
    List<FlSpot> tempExpense = List.generate(
      7,
      (index) => FlSpot(index.toDouble(), 0.0),
    );

    var expenseData = await repository.getWeeklySummary(
      TransactionType.gider.name,
      startOfWeek.toIso8601String(),
    );

    var incomeData = await repository.getWeeklySummary(
      TransactionType.gelir.name,
      startOfWeek.toIso8601String(),
    );

    for (var item in incomeData) {
      int day = int.parse(item['dayOfWeek'].toString());
      int index = (day == 0) ? 6 : (day - 1);
      double y = double.parse(item['total'].toString());

      tempIncome[index] = FlSpot(index.toDouble(), y);
    }

    for (var item in expenseData) {
      int day = int.parse(item['dayOfWeek'].toString());
      int index = (day == 0) ? 6 : (day - 1);
      double y = double.parse(item['total'].toString());

      tempExpense[index] = FlSpot(index.toDouble(), y);
    }

    incomeSpots.assignAll(tempIncome);
    expenseSpots.assignAll(tempExpense);
  }

  void changeTimeFilter(String newFilter) {
    selectedTimeFilter.value = newFilter;
    generateChartData();
  }

  void toggleIncome() {
    if (showIncome.value && !showExpense.value) {
      return;
    }

    showIncome.value = !showIncome.value;
  }

  void toggleExpense() {
    if (showExpense.value && !showIncome.value) {
      return;
    }

    showExpense.value = !showExpense.value;
  }
}
