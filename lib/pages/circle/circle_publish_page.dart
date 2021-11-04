import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/pages/circle/circle_widget/publish_header.dart';
import 'package:stnews/pages/circle/circle_widget/publish_images.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/person/person_widgets/person_tile.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';

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
  List<String> _visibles = [];
  late ValueNotifier<Map> _tileNoti;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
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
            onTap: _publish,
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
          child: PublishHeader(
            titleController: _titleController,
            contentController: _contentController,
          ),
        ),
        SliverToBoxAdapter(
          child: PublishImages(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                            galleryTap: _allVisibles,
                            cameraTap: _onlySelfVisibles,
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

  void _allVisibles() {
    STDebounce().start(
      key: CirclePublishPage.circlePublishDebounceKey,
      func: () {
        _visibles = [];
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

  void _onlySelfVisibles() {
    STDebounce().start(
      key: CirclePublishPage.circlePublishDebounceKey,
      func: () {
        _visibles = [UserProvider.shared.user.id!];
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

  void _publish() {
    if (_titleController.text.isEmpty) {
      STToast.show(context: context, message: '标题不能为空');
      return;
    }
    if (_contentController.text.isEmpty) {
      STToast.show(context: context, message: '内容不能为空');
      return;
    }
    STDebounce().start(
        key: CirclePublishPage.circlePublishDebounceKey,
        func: () async {
          NewsLoading.start(context);
          ResultData result = await Api.addMoment(
            title: _titleController.text,
            content: _contentController.text,
            visibles: _visibles,
            images: _images,
          );
          if (result.success) {
            STRouters.pop(context);
          }
          NewsLoading.stop();
        },
        time: 200);
  }
}
