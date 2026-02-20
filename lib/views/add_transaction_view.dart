import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/viewmodels/transaction_viewmodel.dart';
import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:gelir_gider_takip/widgets/custom_text_field.dart';
import 'package:gelir_gider_takip/widgets/type_toggle.dart';
import 'package:gelir_gider_takip/widgets/date_selector.dart';
import 'package:gelir_gider_takip/widgets/save_button.dart';
import 'package:get/get.dart';

class AddTransactionView extends GetView<TransactionViewModel> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "İşlem Ekle",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TypeToggle(isGider: controller.isGider),
            const SizedBox(height: 25),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<CategoryModel>(
                              value: controller.selectedCategory.value,
                              dropdownColor: const Color(0xFF1E1E1E),
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(12),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white54,
                              ),
                              items: controller.categories.map((cat) {
                                return DropdownMenuItem<CategoryModel>(
                                  value: cat,
                                  child: Row(
                                    children: [
                                      Icon(
                                        IconData(
                                          cat.iconCodePoint,
                                          fontFamily: 'MaterialIcons',
                                        ),
                                        color: const Color(0xFF8DBEAD),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        cat.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                controller.selectedCategory.value = newValue;
                              },
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showAddCategoryDialog(context, controller);
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF8DBEAD),
                          size: 28,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: const Color(0xFF121212),
                    child: const Text(
                      "Kategori",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: amountController,
              label: "Miktar",
              hint: "0.00",
              icon: Icons.payments_outlined,
              isNumber: true,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: descController,
              label: "Açıklama",
              hint: "Not Ekleyin",
              icon: Icons.notes_outlined,
            ),
            const SizedBox(height: 25),
            DateSelector(
              selectedDate: controller.selectedDate,
              onDateSelected: (date) => controller.updateDate(date),
            ),
            const SizedBox(height: 40),
            /*
            _buildSaveButton(
              controller.isGider,
              amountController,
              descController,
              controller,
            ),*/
            SaveButton(
              controller: controller,
              amountController: amountController,
              descController: descController,
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddCategoryDialog(
  BuildContext context,
  TransactionViewModel controller,
) {
  final TextEditingController nameController = TextEditingController();
  final int defaultIcon = Icons.category_outlined.codePoint;

  Get.defaultDialog(
    title: "Yeni Kategori Ekle",
    titleStyle: const TextStyle(color: Colors.white),
    backgroundColor: const Color(0xFF1E1E1E),
    content: Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: nameController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Kategori Adı",
          hintStyle: const TextStyle(color: Colors.white24),
          prefixIcon: const Icon(Icons.edit, color: Color(0xFF8DBEAD)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white24),
          ),
        ),
      ),
    ),
    textConfirm: "Ekle",
    textCancel: "Vazgeç",
    confirmTextColor: Colors.white,
    buttonColor: const Color(0xFF8DBEAD),
    onConfirm: () {
      if (nameController.text.isNotEmpty) {
        controller.addCategory(
          CategoryModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: nameController.text,
            iconCodePoint: defaultIcon,
          ),
        );
        Get.back();
        Get.snackbar(
          "Başarılı",
          "Kategori eklendi",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    },
  );
}
