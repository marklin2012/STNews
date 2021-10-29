import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_widget/publish_header.dart';
import 'package:stnews/pages/circle/circle_widget/publish_images.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/pages/person/person_widgets/person_tile.dart';

import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class CirclePublishPage extends StatefulWidget {
  static const circlePublishDebounceKey = '_circlePublishDebounceKey';
  const CirclePublishPage({Key? key}) : super(key: key);

  @override
  _CirclePublishPageState createState() => _CirclePublishPageState();
}

class _CirclePublishPageState extends State<CirclePublishPage> {
  List<String> _images = [];
  late ValueNotifier<Map> _tileNoti;

  @override
  void initState() {
    super.initState();
    _tileNoti = ValueNotifier({
      'icon': STIcons.commonly_user,
      'title': '谁可以看',
      'isSubTitle': '公开',
    });
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
        title: Text(
          '新动态',
          style: NewsTextStyle.style18BoldBlack,
        ),
        actions: [
          STButton(
            type: STButtonType.text,
            size: STButtonSize.small,
            padding: EdgeInsets.symmetric(horizontal: 16),
            text: '发布',
            textStyle: NewsTextStyle.style17NormalFirBlue,
            onTap: () {},
          ),
        ],
      ),
      body: BlankPutKeyborad(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PublishHeader(),
        ),
        SliverToBoxAdapter(
          child: PublishImages(
            sucImgCallBack: (List<String> images) {
              _images = images;
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 24),
            child: ValueListenableBuilder(
                valueListenable: _tileNoti,
                builder: (BuildContext context, Map value, _) {
                  return PersonTile(
                    data: value,
                    iconColor: ColorConfig.baseFirBule,
                    onTap: () {
                      STDebounce().start(
                        key: CirclePublishPage.circlePublishDebounceKey,
                        func: () {
                          NewsImagePicker.showPicker(
                            context: context,
                            firContent: '公开',
                            secContent: '仅自己可见',
                            galleryTap: _openGallery,
                            cameraTap: _useCamera,
                          );
                        },
                        time: 200,
                      );
                    },
                  );
                }),
          ),
        ),
      ],
    );
  }

  void _openGallery() {
    STDebounce().start(
      key: CirclePublishPage.circlePublishDebounceKey,
      func: () {
        _tileNoti.value = {
          'icon': STIcons.commonly_user,
          'title': '谁可以看',
          'isSubTitle': '公开',
        };
        STRouters.pop(context);
      },
      time: 200,
    );
  }

  void _useCamera() {
    STDebounce().start(
      key: CirclePublishPage.circlePublishDebounceKey,
      func: () {
        _tileNoti.value = {
          'icon': STIcons.commonly_user,
          'title': '谁可以看',
          'isSubTitle': '仅自己可见',
        };
        STRouters.pop(context);
      },
      time: 200,
    );
  }
}
