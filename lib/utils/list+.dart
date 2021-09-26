import 'package:stnews/pages/common/news_perpage.dart';

class STList {
  static bool hasMore(List datas) {
    if (datas.isEmpty || datas.length < NewsPerpage.finalPerPage) {
      return false;
    }
    return true;
  }
}
