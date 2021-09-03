import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/utils/phone_input_formatter.dart';
import 'package:stnews/utils/st_routers.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    Key? key,
    this.onTap,
    required this.areaStr,
    required this.controller,
    this.inputType,
    this.inputFormatters,
    this.placeholder = '输入手机号',
  }) : super(key: key);

  final String areaStr;
  final void Function()? onTap;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final _inputType = inputType ?? TextInputType.number;
    final _inputFormatters = inputFormatters ??
        [
          FilteringTextInputFormatter.allow(RegExp("[ |　]*([0-9])[ |　]*")),
          PhoneInputFormatter(),
          LengthLimitingTextInputFormatter(14)
        ];
    return STInput(
      prefixIcon: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: this.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+' + areaStr,
              style: const TextStyle(
                fontSize: FONTSIZE16,
                fontWeight: FONTWEIGHT400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                STIcons.direction_caretdown,
                size: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      placeholder: placeholder,
      controller: controller,
      inputType: _inputType,
      inputFormatters: _inputFormatters,
    );
  }
}