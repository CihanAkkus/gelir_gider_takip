import 'dart:convert';

enum TransactionType { gelir, gider }

class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "amount": amount,
      "date": date.toIso8601String(),
      "type": type.name,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: json['type'] == 'gelir'
          ? TransactionType.gelir
          : TransactionType.gider,
    );
  }
}
