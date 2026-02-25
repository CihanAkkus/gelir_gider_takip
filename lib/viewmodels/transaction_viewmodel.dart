import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/repositories/transaction_repository.dart';

class TransactionViewModel extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  var transactions =
      <TransactionModel>[].obs; //tüm verilerimizi koruduğumuz liste
  final filteredTransactions = <TransactionModel>[]
      .obs; //verileri ekranda gösterdiğimiz, filtreleme yaptığımız liste
  var categories = <CategoryModel>[].obs;

  var selectedCategory = Rxn<CategoryModel>();
  var selectedDate = DateTime.now().obs;

  var filterDateList = [
    "Tümü",
    "Son 7 Gün",
    "Son 15 Gün",
    "Bu Ay",
    "Son 1 Ay",
    "Son 3 Ay",
    "Son 6 Ay",
    "Bu Yıl",
  ];

  var selectedFilteredCategory = "Tümü".obs;
  var selectedFilteredDate = "Bu Ay".obs;

  var isGider = true.obs;
  String lastQuery = "";

  @override
  void onInit() {
    super.onInit();
    getTransactions();
    getCategories();
  }

  void getCategories() async {
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
    filteredTransactions.assignAll(transactions);

    applyFilters();
  }

  void addTransaction(TransactionModel transaction) async {
    await _repository.addTransaction(transaction);
    transactions.add(transaction);
    searchTransactions("");
  }

  void deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    transactions.removeWhere((element) => element.id == id);
    searchTransactions(lastQuery);
  }

  void clearSearch() {
    searchTransactions("");
  }

  void searchTransactions(String query) {
    this.lastQuery = query; //single source of truth yöntemi
    applyFilters();
  }

  //eğer filtreleme işlemleri çok artarsa, bir helper method ile ayrı bir class-
  //içerisinde yazabiliriz  bu methodu
  void applyFilters() {
    Iterable<TransactionModel> tempIterable = transactions;
    final now = DateTime.now();

    if (lastQuery.isNotEmpty) {
      tempIterable = tempIterable
          .where(
            (item) =>
                item.title.toLowerCase().contains(lastQuery.toLowerCase()),
          );
    }

    if (selectedFilteredCategory.value != "Tümü") {
      tempIterable = tempIterable.where((item) {
        return item.title.toLowerCase() ==
            selectedFilteredCategory.value.toLowerCase();
      });
    }

    if (selectedFilteredDate.value != "Tümü") {
      switch (selectedFilteredDate.value) {
        case "Son 7 Gün":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(now.subtract(Duration(days: 7)));
          });
          break;
        case "Son 15 Gün":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(now.subtract(Duration(days: 15)));
          });
          break;
        case "Bu Ay":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(
              DateTime(now.year, now.month, 1).subtract(Duration(days: 1)),
            );
          });
          break;
        case "Son 1 Ay":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(now.subtract(Duration(days: 30)));
          });
          break;
        case "Son 3 Ay":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(DateTime(now.year, now.month - 3, now.day));
          });
          break;
        case "Son 6 Ay":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(DateTime(now.year, now.month - 6, now.day));
          });
          break;
        case "Bu Yıl":
          tempIterable = tempIterable.where((item) {
            return //item.date.isBefore(now) &&
            item.date.isAfter(
              DateTime(now.year, 1, 1).subtract(Duration(days: 1)),
            );
          });
          break;
      }
    }

    filteredTransactions.assignAll(tempIterable.toList());
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  //toplam gelir ve gider değerleri filtrelere göre çalışabilecek
  double get totalIncome => filteredTransactions
      .where((t) => t.type == TransactionType.gelir)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => filteredTransactions
      .where((t) => t.type == TransactionType.gider)
      .fold(0.0, (sum, item) => sum + item.amount);

  List<String> get categoryNames => [
    "Tümü",
    ...categories.map((category) => category.name).toList(),
  ];
}
