import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/repositories/transaction_repository.dart';

class TransactionViewModel extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  var transactions = <TransactionModel>[].obs;
  var categories = <CategoryModel>[].obs;

  var selectedCategory = Rxn<CategoryModel>();
  var selectedDate = DateTime.now().obs;
  var isGider = true.obs;

  @override
  void onInit() {
    super.onInit();
    getTransactions();
    loadCategories();
  }

  void loadCategories() async {
    var fetchedCategories = await _repository.getCategories();
    categories.assignAll(fetchedCategories);

    if (categories.isNotEmpty) {
      selectedCategory.value = categories[0];
    }
  }

  void addCategory(CategoryModel category) async {
    await _repository.addCategory(category);
    categories.add(category);
  }

  void getTransactions() async {
    var fetchedTransactions = await _repository.getTransactions();
    transactions.assignAll(fetchedTransactions);
  }

  void addTransaction(TransactionModel transaction) async {
    await _repository.addTransaction(transaction);
    transactions.add(transaction);
  }

  void deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    transactions.removeWhere((element) => element.id == id);
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.gelir)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.gider)
      .fold(0.0, (sum, item) => sum + item.amount);
}