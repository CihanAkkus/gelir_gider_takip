import 'package:get/get.dart';

class StatisticsViewModel extends GetxController {
  var selectedTimeFilter = 'Week'.obs;

  final List<String> timeFilters = ['Day', 'Week', 'Month', 'Year'];

  var showIncome = true.obs;
  var showExpense = true.obs;

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
