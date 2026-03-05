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
                      clipData: const FlClipData.none(),
                      minX: -0.3,
                      maxX: statisticsController.maxX + 0.3,
                      minY: 0,
                      borderData: FlBorderData(show: false),

                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: false,
                        drawVerticalLine: true,
                        verticalInterval: 1,
                        //baselineX: 0,
                        checkToShowVerticalLine: (value) {
                          if (value % 1 != 0) return false;

                          final filter =
                              statisticsController.selectedTimeFilter.value;
                          int index = value.toInt();

                          if (index < 0 || index > statisticsController.maxX)
                            return false;

                          switch (filter) {
                            case 'Day':
                              if (index % 4 == 0 || index == 23) return true;
                              return false;
                            case 'Week':
                              return true;
                            case 'Month':
                              if (index % 5 == 0) return true;
                              return false;
                            case 'Year':
                              return true;
                          }
                          return false;
                        },
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
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) {
                              if (value % 1 != 0) return const Text('');

                              int index = value.toInt();

                              if (index < 0 ||
                                  index > statisticsController.maxX)
                                return const Text('');

                              final filter =
                                  statisticsController.selectedTimeFilter.value;
                              String text = '';

                              switch (filter) {
                                case 'Day':
                                  if (index % 4 == 0) {
                                    text =
                                        '${index.toString().padLeft(2, '0')}:00';
                                  } else if (index == 23) {
                                    text = '24:00';
                                  }
                                  break;
                                case 'Week':
                                  const days = [
                                    'M',
                                    'T',
                                    'W',
                                    'T',
                                    'F',
                                    'S',
                                    'S',
                                  ];
                                  if (index >= 0 && index < 7)
                                    text = days[index];
                                  break;
                                case 'Month':
                                  if (index % 5 == 0) {
                                    text = '${index + 1}';
                                  }
                                  break;
                                case 'Year':
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec',
                                  ];
                                  if (index >= 0 && index < 12)
                                    text = months[index];
                                  break;
                              }

                              if (text.isEmpty) return const Text('');

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          show: true,
                          spots: statisticsController.showIncome.value
                              ? statisticsController.incomeSpots.toList()
                              : statisticsController.incomeSpots
                                    .map((e) => FlSpot(e.x, 0))
                                    .toList(),
                          isCurved: true,
                          color: statisticsController.showIncome.value
                              ? AppColors.incomeGreen
                              : Colors.transparent,
                          barWidth: 3.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                statisticsController.showIncome.value
                                    ? AppColors.incomeGreen.withOpacity(0.4)
                                    : Colors.transparent,
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        LineChartBarData(
                          show: true,
                          spots: statisticsController.showExpense.value
                              ? statisticsController.expenseSpots.toList()
                              : statisticsController.expenseSpots
                                    .map((e) => FlSpot(e.x, 0))
                                    .toList(),
                          isCurved: true,
                          color: statisticsController.showExpense.value
                              ? AppColors.expenseRed
                              : Colors.transparent,
                          barWidth: 3.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                statisticsController.showExpense.value
                                    ? AppColors.expenseRed.withOpacity(0.4)
                                    : Colors.transparent,
                                Colors.transparent,
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
