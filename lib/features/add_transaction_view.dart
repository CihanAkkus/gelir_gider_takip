import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/controllers/transaction_controller.dart';
import 'package:gelir_gider_takip/models/category_model.dart';
import 'package:gelir_gider_takip/models/transaction_model.dart';
import 'package:get/get.dart';

class AddTransactionView extends GetView<TransactionController> {
  final TextEditingController categoryController = TextEditingController();
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
            _buildTypeToggle(controller.isGider),
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
                                        cat.iconData,
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

            /*_buildInputField(
              controller: categoryController,
              label: "Kategori",
              hint: "Örn: Eğitim",
              icon: Icons.school_outlined,
            ),*/
            const SizedBox(height: 15),
            _buildInputField(
              controller: amountController,
              label: "Miktar",
              hint: "0.00",
              icon: Icons.payments_outlined,
              isNumber: true,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: descController,
              label: "Açıklama",
              hint: "Not Ekleyin",
              icon: Icons.notes_outlined,
            ),
            const SizedBox(height: 25),
            _buildDateSection(context, controller),
            const SizedBox(height: 40),
            _buildSaveButton(
              controller.isGider,
              amountController,
              descController,
              controller,
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddCategoryDialog(
  BuildContext context,
  TransactionController controller,
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
          snackPosition: .BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    },
  );
}

Widget _buildSaveButton(
  RxBool isGider,

  TextEditingController amount,
  TextEditingController desc,

  TransactionController controller,
) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE5A1AF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
      ),
      onPressed: () {
        if (controller.selectedCategory.value == null || amount.text.isEmpty) {
          Get.snackbar(
            "Uyarı",
            "Lütfen kategori seçin ve miktar alanını doldurun!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }
        ;
        final newTx = TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: controller.selectedCategory.value!.name,
          description: desc.text,
          amount: double.tryParse(amount.text.replaceAll(',', '.')) ?? 0.0,
          date: controller.selectedDate.value,
          type: isGider.value ? .gider : .gelir,
        );
        controller.addTransaction(newTx);
        Get.back();
      },
      child: const Text(
        "Kaydet",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _buildDateSection(
  BuildContext context,
  TransactionController controller,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tarih", style: TextStyle(color: Colors.white54, fontSize: 12)),
          SizedBox(height: 4),
          Obx(
            () => Text(
              "${controller.selectedDate.value.day}.${controller.selectedDate.value.month}.${controller.selectedDate.value.year}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      IconButton(
        onPressed: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: controller.selectedDate.value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.updateDate(picked);
          }
        },
        icon: const Icon(Icons.calendar_month_outlined),
      ),
    ],
  );
}

Widget _buildInputField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  bool isNumber = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        " $label",
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70, size: 22),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8DBEAD)),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTypeToggle(RxBool isGider) {
  return Container(
    height: 48,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white12),
    ),
    child: Obx(
      () => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => isGider.value = true,
              child: Container(
                decoration: BoxDecoration(
                  color: isGider.value
                      ? const Color(0xFF8DBEAD)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_circle_outline,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Gider",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => isGider.value = false,
              child: Container(
                decoration: BoxDecoration(
                  color: !isGider.value
                      ? const Color(0xFF8DBEAD)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Gelir",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
