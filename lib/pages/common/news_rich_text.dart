import 'package:flutter/material.dart';

class NewsRichText extends StatelessWidget {
  const NewsRichText({
    Key? key,
    this.searchContent,
    this.textContent,
    this.frontContent,
    this.fontSize = 16,
    this.fontColor = Colors.black,
    this.selectFontColor = const Color(0xFF095BF9),
  }) : super(key: key);

  ///searchContent    输入的搜索内容
  final String? searchContent;

  ///textContent      需要显示的文字内容
  final String? textContent;

  ///frontContent     需要另外添加在最前面的文字
  final String? frontContent;

  ///fontSize         需要显示的字体大小
  final double? fontSize;

  ///fontColor        需要显示的正常字体颜色
  final Color? fontColor;

  ///selectFontColor  需要显示的搜索字体颜色
  final Color? selectFontColor;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: getTextSpanList(),
      ),
    );
  }

  List<TextSpan> getTextSpanList() {
    List<TextSpan> textSpanList = [];

    if (frontContent != null && frontContent!.isEmpty == false) {
      textSpanList.add(
        TextSpan(
          text: frontContent,
          style: TextStyle(
            fontSize: fontSize,
            color: fontColor,
          ),
        ),
      );
    }

    ///搜索内容不为空
    ///显示内容不为空
    ///并且 显示内容中存在与搜索内容相同的文字
    if (searchContent != null &&
        textContent != null &&
        searchContent!.isEmpty == false &&
        textContent!.contains(searchContent!)) {
      String _textContent = textContent!;
      String _searchContent = searchContent!;
      List<Map> _strMapList = [];
      bool _isContains = true;
      while (_isContains) {
        int startIndex = _textContent.indexOf(searchContent!);
        String showStr = _textContent.substring(
            startIndex, startIndex + _searchContent.length);
        Map _strMap;
        if (startIndex > 0) {
          String normalStr = _textContent.substring(0, startIndex);
          _strMap = Map();
          _strMap['content'] = normalStr;
          _strMap['isHighlight'] = false;
          _strMapList.add(_strMap);
        }
        _strMap = Map();
        _strMap['content'] = showStr;
        _strMap['isHighlight'] = true;
        _strMapList.add(_strMap);
        _textContent = _textContent.substring(
            startIndex + _searchContent.length, _textContent.length);

        _isContains = _textContent.contains(_searchContent);
        if (!_isContains && _textContent != '') {
          _strMap = Map();
          _strMap['content'] = _textContent;
          _strMap['isHighlight'] = false;
          _strMapList.add(_strMap);
        }
      }
      _strMapList.forEach((map) {
        textSpanList.add(TextSpan(
            text: map['content'],
            style: TextStyle(
                fontSize: fontSize,
                color: map['isHighlight'] ? selectFontColor : fontColor)));
      });
    } else {
      ///正常显示所有文字
      textSpanList.add(TextSpan(
        text: textContent,
        style: TextStyle(fontSize: fontSize, color: fontColor),
      ));
    }
    return textSpanList;
  }
}
