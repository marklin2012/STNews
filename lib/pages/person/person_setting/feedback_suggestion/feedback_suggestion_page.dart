import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class FeedbackSuggestionPage extends StatefulWidget {
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
    // _images = ['0', '1', '2', '3', '4'];
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
      resizeToAvoidBottomInset: false,
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
      body: _buildCustomW(),
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
                      color: Theme.of(context).backgroundColor,
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
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              height: _getGridViewHeight(),
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
                itemBuilder: (context, index) {
                  if (index == _images.length) {
                    return _getAddBtn();
                  }
                  return Container(
                    height: 80,
                    color: Colors.primaries[index % Colors.primaries.length],
                  );
                },
                itemCount: _images.length + 1,
              ),
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
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: TextField(
                    controller: _contactCon,
                    decoration: InputDecoration(
                      hintText: '留下联系方式，更可能解决问题',
                      hintStyle: NewsTextStyle.style16NormalFourGrey,
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ),
                SizedBox(height: 68),
                STButton(
                  text: '提交',
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: FONTSIZE18,
                    fontWeight: FONTWEIGHT500,
                  ),
                  mainAxisSize: MainAxisSize.max,
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  double _getGridViewHeight() {
    double _rows = (_images.length + 1.0) / 4.0;
    int _ceil = _rows.ceil();
    final _height = _ceil * 80.0 + (_ceil - 1) * 5.0 + 16.0;
    return _height;
  }

  Widget _getAddBtn() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        NewsImagePicker.showPicker(
          context: context,
          galleryTap: _openGallery,
          cameraTap: _useCamera,
        );
      },
      child: Image(
        image: AssetImage('assets/images/default_add_picture.png'),
      ),
    );
  }

  /// 拍照
  void _useCamera() async {
    await ImagePicker().pickImage(source: ImageSource.camera);
  }

  /// 相册
  void _openGallery() async {
    await ImagePicker()
        .pickMultiImage(maxHeight: 80, maxWidth: 80, imageQuality: 9);
  }
}
