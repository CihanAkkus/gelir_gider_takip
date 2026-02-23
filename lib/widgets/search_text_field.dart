import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.queryChanged,
  });

  final TextEditingController controller;
  final Function(String) queryChanged;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70, size: 22),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF8DBEAD)),
        ),
      ),
      onChanged: (value) {
        queryChanged(value);
      },
    );
  }
}
