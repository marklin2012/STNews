import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_scale.dart';

class AddressModel {
  final bool? isDefault;
  final String? tag;
  final String? province;
  final String? city;
  final String? area;
  final String? county;
  final String? detail;
  final String? name;
  final String? mobile;

  AddressModel({
    Key? key,
    this.isDefault,
    this.tag,
    this.province,
    this.city,
    this.area,
    this.county,
    this.detail,
    this.name,
    this.mobile,
  });
}

class AddressCell extends StatelessWidget {
  const AddressCell({
    Key? key,
    this.isManaged = false,
    this.isSelected = false,
    this.model,
    this.selectedTap,
    this.editTap,
    this.canChoosedTap,
  }) : super(key: key);

  final bool isManaged;

  final bool isSelected;

  final AddressModel? model;

  final Function()? selectedTap;

  final Function()? editTap;

  final Function()? canChoosedTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (canChoosedTap == null) return;
        canChoosedTap!();
      },
      behavior: HitTestBehavior.translucent,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: ColorConfig.backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        reverse: !isManaged,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 48,
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: isSelected
                    ? Icon(
                        Icons.check_box_outlined,
                        size: 24,
                        color: ColorConfig.baseFirBule,
                      )
                    : Icon(
                        Icons.check_box_outline_blank,
                        size: 24,
                      ),
              ),
              onTap: () {
                if (selectedTap == null) return;
                selectedTap!();
              },
            ),
            Container(
              width: NewsScale.screenW(context),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildAddress(),
                  ),
                  STButton.icon(
                    icon: Icon(STIcons.commonly_edit_outline),
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      if (editTap == null) return;
                      editTap!();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (model?.tag != null || model?.isDefault != null) _buildTag(),
              Text(
                '北京朝阳区四环到五环之间',
                style: TextStyle(
                  fontSize: FONTSIZE14,
                  fontWeight: FONTWEIGHT400,
                  color: ColorConfig.textThrColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '广茂路仁爱公寓6楼',
              style: TextStyle(
                fontSize: FONTSIZE14,
                fontWeight: FONTWEIGHT400,
                color: ColorConfig.textFirColor,
              ),
            ),
          ),
          Text(
            '陈小姐 187******68',
            style: TextStyle(
              fontSize: FONTSIZE14,
              fontWeight: FONTWEIGHT400,
              color: ColorConfig.textSecColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag() {
    Color _bgColor = ColorConfig.baseFirBule;
    String _title = model?.tag ?? '';
    if (model?.isDefault != null && model!.isDefault == true) {
      _bgColor = ColorConfig.assistRed;
      _title = '默认';
    }
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _title,
        style: TextStyle(
          fontSize: FONTSIZE14,
          fontWeight: FONTWEIGHT400,
          color: ColorConfig.primaryColor,
        ),
      ),
    );
  }
}
