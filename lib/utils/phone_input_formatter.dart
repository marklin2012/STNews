import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
      } else if (oldValue.text.length == 3) {
        return TextEditingValue(
          text: oldValue.text + " " + newValue.text[newValue.text.length - 1],
          selection: TextSelection(
            baseOffset: oldValue.selection.baseOffset + 2,
            extentOffset: oldValue.selection.extentOffset + 2,
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
      } else if (oldValue.text.length == 8) {
        return TextEditingValue(
          text: oldValue.text + " " + newValue.text[newValue.text.length - 1],
          selection: TextSelection(
            baseOffset: oldValue.selection.baseOffset + 2,
            extentOffset: oldValue.selection.extentOffset + 2,
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
