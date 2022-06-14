// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsMode _$GoodsModeFromJson(Map<String, dynamic> json) => GoodsMode(
      (json['banner'] as List<dynamic>)
          .map((e) => Banner.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['goods'] as List<dynamic>)
          .map((e) => Goods.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GoodsModeToJson(GoodsMode instance) => <String, dynamic>{
      'banner': instance.banner,
      'goods': instance.goods,
    };

Banner _$BannerFromJson(Map<String, dynamic> json) => Banner(
      json['image'] as String,
    );

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
      'image': instance.image,
    };

Goods _$GoodsFromJson(Map<String, dynamic> json) => Goods(
      json['image'] as String,
      json['goodsId'] as String,
    );

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'image': instance.image,
      'goodsId': instance.goodsId,
    };
