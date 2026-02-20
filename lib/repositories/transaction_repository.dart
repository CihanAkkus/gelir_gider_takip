import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/services/db_helper.dart';
import 'package:flutter/material.dart';

class TransactionRepository {


  Future<List<CategoryModel>> getCategories() async {
    var data = await DbHelper.queryCategory();

    if (data.isEmpty) {
      await _createDefultCategories();
      data = await DbHelper.queryCategory();
    }
    return data.map((item) => CategoryModel.fromJson(item)).toList();
  }

  Future<void> _createDefultCategories() async {
    final defaultCategories = [
      CategoryModel(
        id: "1",
        name: "Eğitim",
        iconCodePoint: Icons.school.codePoint,
      ),
      CategoryModel(
        id: "2",
        name: "Yemek",
        iconCodePoint: Icons.restaurant.codePoint,
      ),
      CategoryModel(
        id: "3",
        name: "Ulaşım",
        iconCodePoint: Icons.directions_bus.codePoint,
      ),
    ];

    for (var cat in defaultCategories) {
      await DbHelper.insertCategory(cat);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    await DbHelper.insertCategory(category);
  }

  Future<List<TransactionModel>> getTransactions() async {
    var data = await DbHelper.query();
    return data.map((item) => TransactionModel.fromJson(item)).toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DbHelper.insert(transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await DbHelper.delete(id);
  }
}
