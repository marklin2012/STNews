import 'package:stnews/pages/mall/goods/widgets/mall_home_goods_cell.dart';

class GoodsListsMock {
  static List<MallHomeGoodsModel> setMock() {
    final _goodLists = <MallHomeGoodsModel>[];
    for (int i = 0; i < 10; i++) {
      final _model = MallHomeGoodsModel(
        id: i.toString(),
        title: '爱只为你 音乐盒木质八音盒旋转木马',
        presentPrice: '289.0',
      );
      if (i % 2 == 0) {
        _model.type = MallHomeGoodsTagType.fullMinus;
      } else {
        _model.type = MallHomeGoodsTagType.seckill;
        _model.originalPrice = '320';
      }
      if (i == 2) {
        _model.type = MallHomeGoodsTagType.none;
      }
      _goodLists.add(_model);
    }
    return _goodLists;
  }
}
