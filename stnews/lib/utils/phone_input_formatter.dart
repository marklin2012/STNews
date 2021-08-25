import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // debugPrint('oldValue: $oldValue' + 'newValue: $newValue');
    if (oldValue.text.length < newValue.text.length) {
      // 添加数字
      if (newValue.text.length == 3) {
        return TextEditingValue(
          text: newValue.text + " ",
          selection: TextSelection(
            baseOffset: newValue.selection.baseOffset + 1,
            extentOffset: newValue.selection.extentOffset + 1,
          ),
        );
      } else if (newValue.text.length == 8) {
        return TextEditingValue(
          text: newValue.text + " ",
          selection: TextSelection(
            baseOffset: newValue.selection.baseOffset + 1,
            extentOffset: newValue.selection.extentOffset + 1,
          ),
        );
      }
    } else {
      // 删除数字
      if (newValue.text.length == 9 || newValue.text.length == 4) {
        return TextEditingValue(
          text: newValue.text.substring(0, newValue.text.length - 1),
          selection: TextSelection(
            baseOffset: newValue.selection.baseOffset - 1,
            extentOffset: newValue.selection.extentOffset - 1,
          ),
        );
      }
    }
    return newValue;
  }
}
