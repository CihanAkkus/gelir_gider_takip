import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../viewmodels/statistics_viewmodel.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final statisticsController = Get.find<StatisticsViewModel>();
    final transactionsController = Get.find<TransactionViewModel>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => statisticsController.toggleIncome(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: statisticsController.showIncome.value
                              ? AppColors.incomeGreen.withOpacity(0.1)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: statisticsController.showIncome.value
                                ? AppColors.incomeGreen.withOpacity(0.5)
                                : Colors.white12,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 18,
                              color: statisticsController.showIncome.value
                                  ? AppColors.incomeGreen
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Gelir",
                              style: TextStyle(
                                color: statisticsController.showIncome.value
                                    ? AppColors.incomeGreen
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => statisticsController.toggleExpense(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: statisticsController.showExpense.value
                              ? AppColors.expenseRed.withOpacity(0.1)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: statisticsController.showExpense.value
                                ? AppColors.expenseRed.withOpacity(0.5)
                                : Colors.white12,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              size: 18,
                              color: statisticsController.showExpense.value
                                  ? AppColors.expenseRed
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Gider",
                              style: TextStyle(
                                color: statisticsController.showExpense.value
                                    ? AppColors.expenseRed
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 25),
              Obx(() {
                return Text(
                  "+ ₺ ${transactionsController.totalIncome.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                height: screenHeight * 0.40,
                padding: const EdgeInsets.only(
                  top: 25,
                  bottom: 20,
                  left: 25,
                  right: 25,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Obx(() {
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: false,
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.2),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) {
                              const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < days.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    days[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      //maxY: 11,
                      lineBarsData: [
                        if (statisticsController.showIncome.value)
                          LineChartBarData(
                            spots:statisticsController.incomeSpots.toList(),
                            isCurved: true,
                            color: AppColors.incomeGreen,
                            barWidth: 3.5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.incomeGreen.withOpacity(0.4),
                                  AppColors.incomeGreen.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        if (statisticsController.showExpense.value)
                          LineChartBarData(
                            spots: statisticsController.expenseSpots.toList(),
                            isCurved: true,
                            color: AppColors.expenseRed,
                            barWidth: 3.5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.expenseRed.withOpacity(0.4),
                                  AppColors.expenseRed.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 35),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: statisticsController.timeFilters.map((filter) {
                    final isSelected =
                        statisticsController.selectedTimeFilter.value == filter;
                    return GestureDetector(
                      onTap: () =>
                          statisticsController.changeTimeFilter(filter),
                      child: Column(
                        children: [
                          Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white54,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (isSelected)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (!isSelected) const SizedBox(height: 5),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
