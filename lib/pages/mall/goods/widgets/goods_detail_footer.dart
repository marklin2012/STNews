import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/utils/news_text_style.dart';

class GoodsDetailItem {
  final String title;
  final Widget? icon;
  final Function? onTap;

  const GoodsDetailItem({
    Key? key,
    this.icon,
    required this.title,
    this.onTap,
  });
}

class GoodsDetailFooter extends StatelessWidget {
  const GoodsDetailFooter({
    Key? key,
    required this.items,
    this.height,
    this.triggerAddShoppingCart,
    this.triggerBuyNow,
  }) : super(key: key);

  final double? height;

  final List<GoodsDetailItem> items;

  final Function? triggerAddShoppingCart;

  final Function? triggerBuyNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 49.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: _buildItems()),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 9, 8, 10),
            child: STButton(
              text: '加入购物车',
              radius: 2.0,
              textStyle: NewsTextStyle.style14NormalWhite,
              backgroundColor: ColorConfig.baseSecBule,
              onTap: () {
                if (triggerAddShoppingCart != null) {
                  STDebounce().start(
                    key: '_GoodsDetailFooterDebounceKey',
                    func: () async {
                      triggerAddShoppingCart!();
                    },
                    time: 600,
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 9, bottom: 10),
            child: STButton(
              text: '立即购买',
              radius: 2.0,
              textStyle: NewsTextStyle.style14NormalWhite,
              onTap: () {
                if (triggerBuyNow != null) {
                  STDebounce().start(
                    key: '_GoodsDetailFooterDebounceKey',
                    func: () async {
                      triggerBuyNow!();
                    },
                    time: 600,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 2),
      child: Row(
        children: items.map((e) {
          return Padding(
            padding: EdgeInsets.only(right: e == items.last ? 0 : 20),
            child: _buildItem(e),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItem(GoodsDetailItem item) {
    return GestureDetector(
      onTap: () {
        if (item.onTap != null) item.onTap!();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item.icon != null ? item.icon! : _buildDefaultIcon(),
          Text(
            item.title,
            style: TextStyle(
              color: ColorConfig.textSecColor,
              fontSize: 11.0,
              fontWeight: FONTWEIGHT400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Container(
      height: 20,
      width: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorConfig.secGrey,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'icon',
        style: TextStyle(
          color: ColorConfig.primaryColor,
          fontSize: 10.0,
          fontWeight: FONTWEIGHT400,
        ),
      ),
    );
  }
}
