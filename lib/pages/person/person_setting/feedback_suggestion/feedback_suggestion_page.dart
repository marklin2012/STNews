import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_widget/publish_images.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/phone_input_formatter.dart';
import 'package:stnews/utils/st_routers.dart';

class FeedbackSuggestionPage extends StatefulWidget {
  static const feedbackSuggestionDebounceKey = '_feedbackSuggestionDebounceKey';
  const FeedbackSuggestionPage({Key? key}) : super(key: key);

  @override
  _FeedbackSuggestionPageState createState() => _FeedbackSuggestionPageState();
}

class _FeedbackSuggestionPageState extends State<FeedbackSuggestionPage> {
  late TextEditingController _feedbackCon;
  late TextEditingController _contactCon;
  late ValueNotifier<String> _countNoti;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    final _countStr = '0/100';
    _countNoti = ValueNotifier(_countStr);
    _feedbackCon = TextEditingController()
      ..addListener(() {
        _countNoti.value = '${_feedbackCon.text.length}' + '/100';
      });
    _contactCon = TextEditingController();
    _images = [];
  }

  @override
  void dispose() {
    _feedbackCon.dispose();
    _contactCon.dispose();
    _countNoti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(STIcons.direction_leftoutlined),
          backgroundColor: Colors.transparent,
          onTap: () {
            STRouters.pop(context);
          },
        ),
        title: Text('反馈与建议'),
      ),
      body: BlankPutKeyborad(child: _buildCustomW()),
    );
  }

  Widget _buildCustomW() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '问题和建议',
                      style: NewsTextStyle.style14NormalSecGrey,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _countNoti,
                        builder: (
                          context,
                          String value,
                          child,
                        ) {
                          return Text(
                            value,
                            style: NewsTextStyle.style14NormalSecGrey,
                          );
                        }),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                      color: ColorConfig.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: TextField(
                    controller: _feedbackCon,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '请输入你的问题和建议，感谢你的支持～',
                      hintStyle: NewsTextStyle.style16NormalFourGrey,
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '图片（可提供问题截图）',
                  style: NewsTextStyle.style14NormalSecGrey,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: PublishImages(
              sucImgCallBack: (List<String> images) {
                _images = images;
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  '联系方式',
                  style: NewsTextStyle.style14NormalSecGrey,
                ),
                SizedBox(height: 8),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: ColorConfig.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: TextField(
                    controller: _contactCon,
                    decoration: InputDecoration(
                      hintText: '留下联系方式，更可能解决问题',
                      hintStyle: NewsTextStyle.style16NormalFourGrey,
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(14),
                      PhoneInputFormatter(),
                    ],
                  ),
                ),
                SizedBox(height: 68),
                STButton(
                  text: '提交',
                  textStyle: TextStyle(
                    color: ColorConfig.primaryColor,
                    fontSize: FONTSIZE18,
                    fontWeight: FONTWEIGHT500,
                  ),
                  mainAxisSize: MainAxisSize.max,
                  onTap: _postFeedback,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _postFeedback() {
    if (_feedbackCon.text.isEmpty) {
      STToast.show(context: context, message: '请填写问题和建议');
      return;
    } else if (_contactCon.text.isEmpty) {
      STToast.show(context: context, message: '请留下联系方式');
      return;
    }
    NewsLoading.start(context);
    Api.feedback(
            content: _feedbackCon.text,
            contact: _contactCon.text,
            images: _images)
        .then((reslut) {
      if (reslut.success) {
        STToast.show(context: context, message: '提交成功');
        STRouters.pop(context);
      }
      NewsLoading.stop();
    });
  }
}
