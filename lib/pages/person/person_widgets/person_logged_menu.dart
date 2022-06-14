import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/mall/address/address_manager_page.dart';
import 'package:stnews/pages/mall/orders/my_orders_page.dart';
import 'package:stnews/pages/mall/shoppingCart/shopping_cart_page.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

const _loggedMenus = [
  {'name': '购物车', 'icon': STIcons.commonly_shoppingcart},
  {'name': '我的订单', 'icon': STIcons.commonly_order},
  {'name': '地址管理', 'icon': STIcons.commonly_addressbook},
];

class PersonLoggedMenu extends StatelessWidget {
  const PersonLoggedMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        children: _loggedMenus.map((e) {
          return Ink(
            decoration: BoxDecoration(
              color: ColorConfig.backgroundColor,
            ),
            child: InkWell(
              highlightColor: ColorConfig.accentColor,
              onTap: () {
                _gotoOtherPage(e, context);
              },
              child: Container(
                decoration: e == _loggedMenus.last
                    ? null
                    : BoxDecoration(
                        border: Border(
                          right: BorderSide(color: ColorConfig.thrGrey),
                        ),
                      ),
                height: 78,
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      e['icon'] as IconData,
                      color: ColorConfig.baseFirBule,
                    ),
                    SizedBox(height: 8),
                    Text(
                      e['name'] as String,
                      style: TextStyle(
                        fontSize: FONTSIZE14,
                        fontWeight: FONTWEIGHT400,
                        color: ColorConfig.textFirColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _gotoOtherPage(Map map, BuildContext context) {
    if (map == _loggedMenus.first) {
      STRouters.push(context, ShoppingCartPage());
    } else if (map == _loggedMenus.last) {
      STRouters.push(context, AddressManagePage());
    } else {
      STRouters.push(context, MyOrdersPage());
    }
  }
}
