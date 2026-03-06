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

  var periodTotalIncome = 0.0.obs;
  var periodTotalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    generateChartData();
  }

  double get maxX {
    final filter = selectedTimeFilter.value;
    switch (filter) {
      case 'Day':
        return 23;
      case 'Month':
        return (DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day -
                1)
            .toDouble();
      case 'Year':
        return 11;
      case 'Week':
      default:
        return 6;
    }
  }

  Future<void> generateChartData() async {
    final repository = Get.find<TransactionViewModel>().repository;
    final filter = selectedTimeFilter.value;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime startDate;
    DateTime endDate;
    int spotCount;

    switch (filter) {
      case 'Day':
        startDate = today;
        endDate = today
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        spotCount = 24;
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        spotCount = DateTime(now.year, now.month + 1, 0).day;
        endDate = DateTime(now.year, now.month, spotCount, 23, 59, 59);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31, 23, 59, 59);
        spotCount = 12;
        break;
      case 'Week':
      default:
        startDate = today.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        spotCount = 7;
        break;
    }

    List<FlSpot> tempIncome = List.generate(
      spotCount,
      (index) => FlSpot(index.toDouble(), 0.0),
    );

    List<FlSpot> tempExpense = List.generate(
      spotCount,
      (index) => FlSpot(index.toDouble(), 0.0),
    );

    var expenseData = await repository.getChartSummary(
      TransactionType.gider.name,
      startDate.toIso8601String(),
      endDate.toIso8601String(),
      filter,
    );

    var incomeData = await repository.getChartSummary(
      TransactionType.gelir.name,
      startDate.toIso8601String(),
      endDate.toIso8601String(),
      filter,
    );

    double incTotal = 0;
    for (var item in incomeData) {
      if (item['total'] != null) {
        incTotal += double.parse(item['total'].toString());
      }
    }
    periodTotalIncome.value = incTotal;

    double expTotal = 0;
    for (var item in expenseData) {
      if (item['total'] != null) {
        expTotal += double.parse(item['total'].toString());
      }
    }
    periodTotalExpense.value = expTotal;

    void fillSpots(List<Map<String, dynamic>> data, List<FlSpot> spots) {
      for (var item in data) {
        if (item['timeUnit'] == null) continue;

        int timeUnit = int.parse(item['timeUnit'].toString());
        double y = double.parse(item['total'].toString());
        int index = filter == 'Day'
            ? timeUnit
            : (filter == 'Week'
                  ? ((timeUnit == 0) ? 6 : (timeUnit - 1))
                  : timeUnit - 1);

        if (index >= 0 && index < spotCount) {
          spots[index] = FlSpot(index.toDouble(), y);
        }
      }
    }

    fillSpots(incomeData, tempIncome);
    fillSpots(expenseData, tempExpense);

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
