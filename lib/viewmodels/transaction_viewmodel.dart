import 'package:flutter/cupertino.dart';
import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:gelir_gider_takip/repositories/transaction_repository.dart';
import '../services/db_helper.dart';

class TransactionViewModel extends GetxController {
  //controllers, memory leak için önlem
  final TextEditingController queryController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final TransactionRepository repository;

  TransactionViewModel({required this.repository}); //CONSTRUCTOR

  int _currentOffset = 0;
  final int _limit =
      20; //const yapmadık çünkü ilerde değiştirebilirim run-time ile belli olsun

  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  var transactions =
      <TransactionModel>[].obs; //tüm verilerimizi koruduğumuz liste
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

  var _totalIncome = 0.0.obs;
  var _totalExpense = 0.0.obs;

  double get totalIncome => _totalIncome.value;
  double get totalExpense => _totalExpense.value;

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
    isLoadingMore.value = true;

    _fetchTotals();

    var fetchedTransactions = await repository.getTransactions(
      limit: _limit,
      offset: _currentOffset,
      searchQuery: lastQuery,
      categoryName: selectedFilteredCategory.value,
      startDate: _getStartDateString(),
    );
    transactions.assignAll(fetchedTransactions);

    if (fetchedTransactions.length < _limit) {
      hasMoreData.value = false;
    }
    isLoadingMore.value = false;
  }

  void loadMoreTransactions() async {
    if (!hasMoreData.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    _currentOffset += _limit;

    var fetchedTransactions = await repository.getTransactions(
      limit: _limit,
      offset: _currentOffset,
      searchQuery: lastQuery,
      categoryName: selectedFilteredCategory.value,
      startDate: _getStartDateString(),
    );

    if (fetchedTransactions.isEmpty) {
      hasMoreData.value = false;
    } else {
      transactions.addAll(fetchedTransactions);
      if (fetchedTransactions.length < _limit) {
        hasMoreData.value = false;
      }
    }
    isLoadingMore.value = false;
  }

  void addTransaction(TransactionModel transaction) async {
    await repository.addTransaction(transaction);
    //transactions.add(transaction);
    searchTransactions("");
  }

  void deleteTransaction(String id) async {
    await repository.deleteTransaction(id);
    //transactions.removeWhere((element) => element.id == id);
    searchTransactions(lastQuery);
  }

  void clearSearch() {
    searchTransactions("");
  }

  void searchTransactions(String query) {
    this.lastQuery = query; //single source of truth yöntemi
    applyFilters();
  }

  String? _getStartDateString() {
    final now = DateTime.now();
    DateTime? targetDate;

    switch (selectedFilteredDate.value) {
      case "Son 7 Gün":
        targetDate = now.subtract(const Duration(days: 7));
        break;
      case "Son 15 Gün":
        targetDate = now.subtract(const Duration(days: 15));
        break;
      case "Bu Ay":
        targetDate = DateTime(
          now.year,
          now.month,
          1,
        ).subtract(const Duration(days: 1));
        break;
      case "Son 1 Ay":
        targetDate = now.subtract(const Duration(days: 30));
        break;
      case "Son 3 Ay":
        targetDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case "Son 6 Ay":
        targetDate = DateTime(now.year, now.month - 6, now.day);
        break;
      case "Bu Yıl":
        targetDate = DateTime(now.year, 1, 1).subtract(const Duration(days: 1));
        break;
      case "Tümü":
      default:
        return null;
    }
    return targetDate.toIso8601String();
  }

  //eğer filtreleme işlemleri çok artarsa, bir helper method ile ayrı bir class-
  //içerisinde yazabiliriz  bu methodu
  void applyFilters() {
    getTransactions();
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> _fetchTotals() async {
    _totalIncome.value = await repository.getTotalAmount(
      TransactionType.gelir.name,
      searchQuery: lastQuery,
      categoryName: selectedFilteredCategory.value,
      startDate: _getStartDateString(),
    );

    _totalExpense.value = await repository.getTotalAmount(
      TransactionType.gider.name,
      searchQuery: lastQuery,
      categoryName: selectedFilteredCategory.value,
      startDate: _getStartDateString(),
    );
  }


  List<String> get categoryNames => [
    "Tümü",
    ...categories.map((category) => category.name).toList(),
  ];
}
