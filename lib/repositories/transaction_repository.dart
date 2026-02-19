import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/services/db_helper.dart';

class TransactionRepository {

  void loadCategories() async {
    var data = await DbHelper.queryCategory();

    if (data.isEmpty) {
      await _createDefultCategories();
      data = await DbHelper.queryCategory();
    }

    categories.assignAll(
      data.map((item) => CategoryModel.fromJson(item)).toList(),
    );

    if (categories.isNotEmpty) {
      selectedCategory.value = categories[0];
    }
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

  void addCategory(CategoryModel category) async {
    await DbHelper.insertCategory(category);
    categories.add(category);
  }

  void getTransactions() async {
    var data = await DbHelper.query();

    transactions.assignAll(
      data.map((item) => TransactionModel.fromJson(item)).toList(),
    );
  }

  void addTransaction(TransactionModel transaction) async {
    await DbHelper.insert(transaction);

    transactions.add(transaction);
  }

  void deleteTransaction(String id) async {
    await DbHelper.delete(id);

    transactions.removeWhere((element) => element.id == id);
  }


}