import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeToggle extends StatelessWidget {
  final RxBool isGider;

  const TypeToggle({super.key, required this.isGider});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white12),
      ),
      child: Obx(
            () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => isGider.value = true,
                child: Container(
                  decoration: BoxDecoration(
                    color: isGider.value
                        ? const Color(0xFF8DBEAD)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_circle_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Gider",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => isGider.value = false,
                child: Container(
                  decoration: BoxDecoration(
                    color: !isGider.value
                        ? const Color(0xFF8DBEAD)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Gelir",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}