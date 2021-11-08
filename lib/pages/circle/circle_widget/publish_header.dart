import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';

class PublishHeader extends StatefulWidget {
  const PublishHeader({
    Key? key,
    this.titleController,
    this.contentController,
  }) : super(key: key);

  final TextEditingController? titleController;
  final TextEditingController? contentController;

  @override
  _PublishHeaderState createState() => _PublishHeaderState();
}

class _PublishHeaderState extends State<PublishHeader> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late ValueNotifier<String> _titleNumNoti;

  @override
  void initState() {
    super.initState();
    _titleNumNoti = ValueNotifier('0/18');
    _titleController = widget.titleController ?? TextEditingController();
    _titleController.addListener(() {
      _titleNumNoti.value = '${_titleController.text.length}/18';
    });
    _contentController = widget.contentController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTitle(),
          Container(
            width: NewsScale.screenW(context) - 32,
            height: 120,
            padding: EdgeInsets.only(top: 8),
            alignment: Alignment.topLeft,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                hintText: '添加正文内容',
                hintStyle: NewsTextStyle.style16NormalThrGrey,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
              maxLines: 4,
              controller: _contentController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorConfig.fourGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: STInput(
              controller: _titleController,
              decoration: BoxDecoration(color: Colors.transparent),
              padding: EdgeInsets.zero,
              placeholder: '添加标题',
              placeholderStyle: NewsTextStyle.style16NormalThrGrey,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _titleNumNoti,
            builder: (BuildContext context, String value, _) {
              return Text(
                value,
                style: NewsTextStyle.style14NormalThrGrey,
              );
            },
          ),
        ],
      ),
    );
  }
}
