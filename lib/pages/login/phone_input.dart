import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/phone_input_formatter.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    Key? key,
    this.onTap,
    this.onChanged,
    required this.areaStr,
    required this.controller,
    this.inputType,
    this.inputFormatters,
    this.placeholder = '输入手机号',
    this.focusNode,
    this.phoneLength = 11,
  }) : super(key: key);

  final String areaStr;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? placeholder;
  final FocusNode? focusNode;
  final int phoneLength;

  @override
  Widget build(BuildContext context) {
    final _focusNode = focusNode ?? FocusNode();
    final _inputType = inputType ?? TextInputType.number;
    final _limitLength = _calculateLimitLength();
    final _inputFormatters = inputFormatters ??
        [
          FilteringTextInputFormatter.allow(RegExp("[ |　]*([0-9])[ |　]*")),
          PhoneInputFormatter(),
          LengthLimitingTextInputFormatter(_limitLength),
        ];
    return STInput(
      backgoundColor: ColorConfig.primaryColor,
      textStyle: NewsTextStyle.style16NormalBlack,
      prefixIcon: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: this.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+' + areaStr,
              style: NewsTextStyle.style16NormalBlack,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                STIcons.direction_caretdown,
                size: 14,
                color: ColorConfig.textFirColor,
              ),
            ),
          ],
        ),
      ),
      placeholder: placeholder,
      controller: controller,
      inputType: _inputType,
      inputFormatters: _inputFormatters,
      focusNode: _focusNode,
      onChanged: (String value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }

  int _calculateLimitLength() {
    if (phoneLength > 7) {
      return phoneLength + 2;
    } else if (phoneLength > 3) {
      return phoneLength + 1;
    } else {
      return phoneLength;
    }
  }
}
