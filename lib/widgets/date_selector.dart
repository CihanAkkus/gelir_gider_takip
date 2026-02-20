import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateSelector extends StatelessWidget {
  final Rx<DateTime> selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tarih", style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            Obx(
                  () => Text(
                "${selectedDate.value.day}.${selectedDate.value.month}.${selectedDate.value.year}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate.value,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ],
    );
  }
}