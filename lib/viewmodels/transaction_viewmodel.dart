import 'package:flutter/cupertino.dart';
import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/repositories/transaction_repository.dart';

class TransactionViewModel extends GetxController {

  //controllers, memory leak için önlem
  final TextEditingController queryController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final TransactionRepository repository;

  TransactionViewModel({required this.repository});//CONSTRUCTOR




  int _currentOffset = 0;
  final int _limit =
      20; //const yapmadık çünkü ilerde değiştirebilirim run-time ile belli olsun

  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

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

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 150) {
      loadMoreTransactions();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    queryController.dispose();
    amountController.dispose();
    descController.dispose();
    super.onClose();
  }

  void getCategories() async {
    var fetchedCategories = await repository.getCategories();
    categories.assignAll(fetchedCategories);

    if (categories.isNotEmpty) {
      selectedCategory.value = categories[0];
    }
  }

  void addCategory(CategoryModel category) async {
    await repository.addCategory(category);
    categories.add(category);
  }

  void getTransactions() async {
    _currentOffset = 0;
    hasMoreData.value = true;

    var fetchedTransactions = await repository.getTransactions(
      limit: _limit,
      offset: _currentOffset,
    );
    transactions.assignAll(fetchedTransactions);

    if (fetchedTransactions.length < _limit) {
      hasMoreData.value = false;
    }

    applyFilters();
  }

  void loadMoreTransactions() async {
    if (!hasMoreData.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    _currentOffset += _limit;

    var fetchedTransactions = await repository.getTransactions(
      limit: _limit,
      offset: _currentOffset,
    );

    if (fetchedTransactions.isEmpty) {
      hasMoreData.value = false;
    } else {
      transactions.addAll(fetchedTransactions);
      if (fetchedTransactions.length < _limit) {
        hasMoreData.value = false;
      }
      applyFilters();
    }
    isLoadingMore.value = false;
  }

  void addTransaction(TransactionModel transaction) async {
    await repository.addTransaction(transaction);
    transactions.add(transaction);
    searchTransactions("");
  }

  void deleteTransaction(String id) async {
    await repository.deleteTransaction(id);
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
      tempIterable = tempIterable.where(
        (item) => item.title.toLowerCase().contains(lastQuery.toLowerCase()),
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
