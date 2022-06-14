import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/empty_view_widget.dart';
import 'package:stnews/utils/news_text_style.dart';

class PaySuccessPage extends StatefulWidget {
  const PaySuccessPage({Key? key}) : super(key: key);

  @override
  State<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends State<PaySuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          EmptyViewWidget(
            image: SizedBox(
              height: 80,
              width: 80,
              child: Icon(
                STIcons.status_checkcircle,
                color: ColorConfig.baseFirBule,
                size: 66,
              ),
            ),
            content: '支付成功',
            textStyle: NewsTextStyle.style16BoldBlack,
            descript: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '在我的订单里可以查看订单状态',
                style: NewsTextStyle.style14NormalSecGrey,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 64),
            child: STButton(
              radius: 4,
              text: '返回商城',
              textStyle: NewsTextStyle.style16NormalWhite,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
