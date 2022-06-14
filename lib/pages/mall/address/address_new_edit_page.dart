import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/address/widgets/address_cell.dart';
import 'package:stnews/utils/news_text_style.dart';

class AddressNewEditPage extends StatefulWidget {
  const AddressNewEditPage({
    Key? key,
    this.model,
  }) : super(key: key);

  final AddressModel? model;

  @override
  State<AddressNewEditPage> createState() => _AddressNewEditPageState();
}

const addressTags = ['家', '公司', '学校'];

class _AddressNewEditPageState extends State<AddressNewEditPage> {
  bool get _isEdit => widget.model != null;
  late ValueNotifier<bool> _defaultAddressNoti;

  final tipTextStyle = NewsTextStyle.style16NormalSecGrey;

  @override
  void initState() {
    super.initState();
    final _isDefault = widget.model?.isDefault ?? false;
    _defaultAddressNoti = ValueNotifier(_isDefault);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? '编辑地址' : '新建地址'),
        actions: [
          STButton(
            text: '保存',
            textStyle: NewsTextStyle.style17NormalBlack,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            onTap: () {},
          ),
        ],
      ),
      body: STUnFocus(
          child: Column(
        children: [
          Form(child: _buildForm()),
          _buildBottom(),
        ],
      )),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: EdgeInsets.only(top: 24),
      child: Column(
        children: [
          STRowOption(
            leading: SizedBox(
              width: 64,
              child: Text('收件人', style: tipTextStyle),
            ),
            center: STFormInput(
              placeholder: '姓名',
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ),
          STRowOption(
            leading: SizedBox(
              width: 64,
              child: Text('手机号码', style: tipTextStyle),
            ),
            center: STFormInput(
              placeholder: '请输入手机号码',
              inputFormatters: [
                LengthLimitingTextInputFormatter(14),
              ],
            ),
          ),
          STRowOption(
            leading: SizedBox(
              width: 64,
              child: Text('选择地区', style: tipTextStyle),
            ),
            center: _selectArea(),
            isHavRightArrow: true,
          ),
          STRowOption(
            leading: Container(
              width: 64,
              padding: EdgeInsets.only(top: 11),
              child: Text('详细地址', style: tipTextStyle),
            ),
            contentCrossAlignment: CrossAxisAlignment.start,
            center: Container(
              height: 110,
              alignment: Alignment.topLeft,
              child: STFormInput(
                height: 110,
                cursorHeight: 24,
                maxLines: 4,
                placeholder: '街道、楼牌号等',
              ),
            ),
            isHavBottomLine: false,
          ),
        ],
      ),
    );
  }

  Widget _selectArea() {
    return STSelect(
      types: STSelectTypes.texts,
      title: '选择省市区',
      textsListValues: [
        ['第一列1', '第一列2', '第一列3', '第一列4', '第一列5', '第一列6'],
        ['第二列1', '第二列2', '第二列3', '第二列4', '第二列5', '第二列6'],
        ['第三列1', '第三列2', '第三列3', '第三列4', '第三列5', '第三列6'],
      ],
      onChangedTextsValue: (List<String> value) {},
      child: Text(
        '省、市、区',
        style: NewsTextStyle.style16NormalFourGrey,
      ),
    );
  }

  Widget _buildBottom() {
    final _tagsW = <Widget>[];
    _tagsW.add(
      SizedBox(
        width: 92,
        child: Text(
          '标签',
          style: tipTextStyle,
        ),
      ),
    );
    for (final item in addressTags) {
      final _temp = Container(
        margin: EdgeInsets.only(right: item == addressTags.last ? 0 : 16),
        child: STButton(
          text: item,
          textStyle: NewsTextStyle.style14NormalBlack,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          radius: 4,
          type: STButtonType.outline,
          borderColor: ColorConfig.fourGrey,
          onTap: () {},
        ),
      );
      _tagsW.add(_temp);
    }
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: ColorConfig.backgroundColor,
      child: Column(
        children: [
          Container(
            height: 48,
            child: Row(
              children: _tagsW,
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: ColorConfig.fourGrey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '设为默认地址',
                  style: tipTextStyle,
                ),
                ValueListenableBuilder(
                  valueListenable: _defaultAddressNoti,
                  builder: (context, bool isDefault, _) {
                    return STSwitch(
                      value: isDefault,
                      onChanged: (bool value) {
                        _defaultAddressNoti.value = value;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
