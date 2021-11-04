import 'package:stnews/pages/common/news_perpage.dart';

class STList {
  static bool hasMore(List datas, {int? perpage}) {
    final _perpage = perpage ?? NewsPerpage.finalPerPage;
    if (datas.isEmpty || datas.length < _perpage) {
      return false;
    }
    return true;
  }
}
