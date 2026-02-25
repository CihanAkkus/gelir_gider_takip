import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickerHelper {
  static Future showWheelPicker(
    BuildContext context,
    RxString filteredValue,
    List<String> wheelList,
    Function() onConfirm,
  ) async {
    String temporalFilteredValue = filteredValue.value;
    int initialIndex = wheelList.indexOf(filteredValue.value);

    if (initialIndex == -1) {
      initialIndex = 0;
    }

    return await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Color(0xFF1E1E1E),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  child: const Text(
                    "Vazgeç",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  child: Text(
                    "Tamam",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    filteredValue.value = temporalFilteredValue;
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: initialIndex,
                ),
                itemExtent: 40,
                magnification: 1.2,
                useMagnifier: true,
                onSelectedItemChanged: (index) {
                  temporalFilteredValue = wheelList[index];
                },
                children: wheelList.map((e) => Center(child: Text(e))).toList(),
              ),
            ),
            SizedBox(height: 65),
          ],
        ),
      ),
    );
  }
}
