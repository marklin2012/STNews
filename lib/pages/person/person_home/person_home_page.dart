import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:saturn/saturn.dart';

import 'package:stnews/pages/common/news_loading.dart';
import 'package:stnews/pages/person/person_widgets/person_home_circles.dart';
import 'package:stnews/pages/person/person_widgets/person_home_header.dart';
import 'package:stnews/pages/person/person_widgets/person_home_posts.dart';
import 'package:stnews/providers/user_home_provider.dart';
import 'package:stnews/utils/news_text_style.dart';
import 'package:stnews/utils/st_routers.dart';

enum PersonHomeShowType {
  PersonHomeShowPost,
  PersonHomeShowCircle,
}

class PersonHomePage extends StatefulWidget {
  const PersonHomePage({
    Key? key,
    this.userID,
    required this.type,
  }) : super(key: key);

  final String? userID;

  final PersonHomeShowType type;

  @override
  _PersonHomePageState createState() => _PersonHomePageState();
}

class _PersonHomePageState extends State<PersonHomePage> {
  UserHomeProvider get userHomeProvider =>
      Provider.of<UserHomeProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      userHomeProvider.userID = widget.userID ?? '';
      _requestData();
    });
  }

  Future _requestData() async {
    NewsLoading.start(context);
    await userHomeProvider.getUserInfoData();
    await userHomeProvider.getFavouritedUser();
    NewsLoading.stop();
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
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        PersonHomeHeader(userID: widget.userID ?? ''),
        if (widget.type == PersonHomeShowType.PersonHomeShowPost)
          PersonHomePosts(),
        if (widget.type == PersonHomeShowType.PersonHomeShowCircle)
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'TA的作品',
                style: NewsTextStyle.style17BoldBlack,
              ),
            ),
          ),
        if (widget.type == PersonHomeShowType.PersonHomeShowCircle)
          PersonHomeCircles(),
      ],
    );
  }
}
