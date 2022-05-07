import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/pages/circle/circle_widget/publish_header.dart';
import 'package:stnews/pages/circle/circle_widget/publish_images.dart';
import 'package:stnews/pages/common/color_config.dart';
import 'package:stnews/pages/common/news_image_picker.dart';
import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/person/person_widgets/person_tile.dart';
import 'package:stnews/providers/circle_provider.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/blank_put_keyborad.dart';

import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

class CirclePublishPage extends StatefulWidget {
  static const circlePublishDebounceKey = '_circlePublishDebounceKey';
  const CirclePublishPage({Key? key, this.model}) : super(key: key);
  final MomentModel? model;

  @override
  _CirclePublishPageState createState() => _CirclePublishPageState();
}

class _CirclePublishPageState extends State<CirclePublishPage> {
  List<String> _images = [];
  List<String> _visibles = [];
  late ValueNotifier<Map> _tileNoti;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late ValueNotifier<bool> _publishNoti;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    bool _publishDisable = true;
    Map _tileMap = {
      'icon': STIcons.commonly_user,
      'title': '谁可以看',
      'isSubTitle': '公开',
    };
    if (widget.model != null) {
      _publishDisable = false;
      _titleController.text = widget.model!.title ?? '';
      _contentController.text = widget.model!.content ?? '';
      _images = widget.model!.images ?? [];
      if (widget.model?.visibles != null) {
        for (final temp in widget.model!.visibles!) {
          if (temp == UserProvider.shared.user.id) {
            _tileMap['isSubTitle'] = '仅自己可见';
            break;
          }
        }
      }
    }
    _publishNoti = ValueNotifier(_publishDisable);
    _tileNoti = ValueNotifier(_tileMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: STButton.icon(
          icon: Icon(
            STIcons.commonly_close_outline,
            size: 16,
          ),
          padding: EdgeInsets.all(8.0),
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
          ValueListenableBuilder(
            valueListenable: _publishNoti,
            builder: (context, bool value, _) {
              return STButton(
                type: STButtonType.text,
                size: STButtonSize.small,
                disabled: value,
                padding: EdgeInsets.symmetric(horizontal: 16),
                text: '发布',
                textStyle: NewsTextStyle.style17NormalFirBlue,
                onTap: _publishAction,
              );
            },
          )
        ],
      ),
      body: BlankPutKeyborad(
        child: _buildContent(),
      ),
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
            images: _images,
            crossAxisCount: 3,
            imageSize: 111,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16),
            sucImgCallBack: (List<String> images) {
              _images = images;
              if (_images.isNotEmpty) {
                _publishNoti.value = false;
              } else {
                _publishNoti.value = true;
              }
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

  void _publishAction() {
    if (widget.model == null) {
      _publish();
    } else {
      _update();
    }
  }

  void _update() {
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
        ResultData result = await Api.updateMoment(
          moment: widget.model!.id!,
          title: _titleController.text,
          content: _contentController.text,
          visibles: _visibles,
          images: _images,
        );
        if (result.success) {
          STRouters.pop(context);
          STToast.show(context: context, message: '更新成功');
          Provider.of<CircleProvider>(context, listen: false).initData();
          await UserProvider.shared
              .getUserInfo(userID: UserProvider.shared.info.user?.id);
          Provider.of<UserHomeProvider>(context, listen: false).updateMoment();
        }
        NewsLoading.stop();
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
          STToast.show(context: context, message: '发布成功');
          Provider.of<CircleProvider>(context, listen: false).initData();
          await UserProvider.shared
              .getUserInfo(userID: UserProvider.shared.info.user?.id);
          Provider.of<UserHomeProvider>(context, listen: false).updateMoment();
        }
        NewsLoading.stop();
      },
      time: 200,
    );
  }
}
