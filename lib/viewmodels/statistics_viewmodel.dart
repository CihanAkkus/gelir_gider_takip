import 'package:fl_chart/fl_chart.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:get/get.dart';

class StatisticsViewModel extends GetxController {
  var selectedTimeFilter = 'Week'.obs;

  final List<String> timeFilters = ['Day', 'Week', 'Month', 'Year'];

  final RxList<FlSpot> incomeSpots = <FlSpot>[].obs;
  final RxList<FlSpot> expenseSpots = <FlSpot>[].obs;

  var showIncome = true.obs;
  var showExpense = true.obs;

  void generateChartData() {
    var txController = Get.find<TransactionViewModel>();

  }

  void changeTimeFilter(String newFilter) {
    selectedTimeFilter.value = newFilter;
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
