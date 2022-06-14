import 'package:json_annotation/json_annotation.dart';
part 'test_model.g.dart';

@JsonSerializable()
class GoodsMode extends Object {
  @JsonKey(name: 'banner')
  List<Banner> banner;
  @JsonKey(name: 'goods')
  List<Goods> goods;
  GoodsMode(
    this.banner,
    this.goods,
  );
  factory GoodsMode.fromJson(Map<String, dynamic> srcJson) =>
      _$GoodsModeFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GoodsModeToJson(this);
}

@JsonSerializable()
class Banner extends Object {
  @JsonKey(name: 'image')
  String image;
  Banner(
    this.image,
  );
  factory Banner.fromJson(Map<String, dynamic> srcJson) =>
      _$BannerFromJson(srcJson);
  Map<String, dynamic> toJson() => _$BannerToJson(this);
}

@JsonSerializable()
class Goods extends Object {
  @JsonKey(name: 'image')
  String image;
  @JsonKey(name: 'goodsId')
  String goodsId;
  Goods(
    this.image,
    this.goodsId,
  );
  factory Goods.fromJson(Map<String, dynamic> srcJson) =>
      _$GoodsFromJson(srcJson);
  Map<String, dynamic> toJson() => _$GoodsToJson(this);
}

class TestJson {
  Map<String, dynamic> datas = {
    "GoodsMode": {
      "banner": [
        {
          "image":
              "http://images.baixingliangfan.cn/compressedPic/20181210150050_5409.jpg"
        },
        {
          "image":
              "http://images.baixingliangfan.cn/compressedPic/20181210150050_5409.jpg"
        },
        {
          "image":
              "http://images.baixingliangfan.cn/compressedPic/20181210150050_5409.jpg"
        }
      ],
      "goods": [
        {
          "image":
              "http://images.baixingliangfan.cn/homeFloor/20190116/20190116133522_9332.jpg",
          "goodsId": "faa86c6ee451445a9475870656f04192"
        },
        {
          "image":
              "http://images.baixingliangfan.cn/homeFloor/20190116/20190116135616_4151.jpg",
          "goodsId": "80817b9fd00b48f296ce939ae197030b"
        },
        {
          "image":
              "http://images.baixingliangfan.cn/homeFloor/20190116/20190116133626_1248.jpg",
          "goodsId": "00cee04d12474910bfeb7930f6251c22"
        },
        {
          "image":
              "http://images.baixingliangfan.cn/homeFloor/20190116/20190116133740_8452.jpg",
          "goodsId": "bdfa9a9a358f436594a740e486fd2060"
        },
        {
          "image":
              "http://images.baixingliangfan.cn/homeFloor/20190116/20190116133753_7874.jpg",
          "goodsId": "516f9db6ee8e499cb8a8758cf2e567c7"
        }
      ]
    }
  };
}

Future<GoodsMode> getGoodsMode() async {
  final _json = TestJson().datas;
  final _map = _json['GoodsMode'];
  final _goodsMode = GoodsMode.fromJson(_map);
  return _goodsMode;
}
