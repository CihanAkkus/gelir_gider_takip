// lib/mock_data.dart
import 'dart:math';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/models/category_model.dart';

import '../services/db_helper.dart';


final Random random = Random();

// ------------------ Yardımcı Fonksiyonlar ------------------ //

String getRandomTitle() {
  const titles = [
    "Market Alışverişi",
    "Elektrik Faturası",
    "Kira Ödemesi",
    "Restoran",
    "Kahve",
    "Online Alışveriş",
    "Yakıt",
    "Kitap",
    "Sinema",
    "Hediye"
  ];
  return titles[random.nextInt(titles.length)];
}

double getRandomAmount() {
  return (random.nextDouble() * 500).roundToDouble();
}

DateTime getRandomDate() {
  int daysBack = random.nextInt(90);
  return DateTime.now().subtract(Duration(days: daysBack));
}

TransactionType getRandomTypeEnum() {
  return random.nextBool() ? TransactionType.gelir : TransactionType.gider;
}

// ------------------ Mock Kategori Ekleme ------------------ //

Future<void> insertMockCategories() async {
  List<CategoryModel> categories = [
    CategoryModel(id: "cat1", name: "Market", iconCodePoint: 0xe8cc),
    CategoryModel(id: "cat2", name: "Fatura", iconCodePoint: 0xe53e),
    CategoryModel(id: "cat3", name: "Kira", iconCodePoint: 0xe88a),
    CategoryModel(id: "cat4", name: "Restoran", iconCodePoint: 0xe56c),
    CategoryModel(id: "cat5", name: "Kahve", iconCodePoint: 0xe561),
    CategoryModel(id: "cat6", name: "Online Alışveriş", iconCodePoint: 0xe14c),
    CategoryModel(id: "cat7", name: "Yakıt", iconCodePoint: 0xe7c4),
    CategoryModel(id: "cat8", name: "Kitap", iconCodePoint: 0xe865),
    CategoryModel(id: "cat9", name: "Sinema", iconCodePoint: 0xe039),
    CategoryModel(id: "cat10", name: "Hediye", iconCodePoint: 0xe8ce),
  ];

  for (var cat in categories) {
    await DbHelper.insertCategory(cat);
  }
  print("10 mock kategori eklendi!");
}

// ------------------ Mock Transaction Ekleme ------------------ //

Future<void> insertMockTransactions(int count) async {
  for (int i = 0; i < count; i++) {
    TransactionModel transaction = TransactionModel(
      id: "txn_${i + 1}",
      title: getRandomTitle(),
      description: "Test açıklama ${i + 1}",
      amount: getRandomAmount(),
      date: getRandomDate(),
      type: getRandomTypeEnum(),
    );
    await DbHelper.insert(transaction);
  }
  print("$count mock transaction eklendi!");
}

// ------------------ Tek Satırla Çalıştırılabilir ------------------ //

Future<void> runMockData() async {
  await DbHelper.initDb();
  await insertMockCategories();
  await insertMockTransactions(60);
  print("✅ Mock data ekleme tamamlandı!");
}