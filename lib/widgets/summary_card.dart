import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final Widget amount;
  final Color color;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          amount,
        ],
      ),
    );
  }
}
