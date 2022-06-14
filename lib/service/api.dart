import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stnews/pages/common/news_toast.dart';
import 'package:stnews/pages/common/token_invalid.dart';

import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/result_data.dart';

const TimeoutConnect = 5000;
const TimeoutReceive = 8000;
const TimeoutSend = 3000;

// iOS
const String BaseUrl = 'http://localhost:7001/';
// andriod
// const String BaseUrl = 'http://192.168.2.138:7001/';
// const String BaseUrl = 'http://120.78.145.47:7001/';

Dio dio = Dio();

/// error 统一处理
String _formatError(DioError e) {
  switch (e.type) {
    case DioErrorType.connectTimeout:
      debugPrint('连接超时');
      return '连接超时';
    case DioErrorType.sendTimeout:
      debugPrint('请求超时');
      return '请求超时';
    case DioErrorType.receiveTimeout:
      debugPrint('响应超时');
      return '响应超时';
    case DioErrorType.response:
      debugPrint('出现异常');
      return '出现异常';
    case DioErrorType.cancel:
      debugPrint('请求取消');
      return '请求取消';
    default:
      debugPrint("未知错误");
      return '未知错误';
  }
}

Future<ResultData> _get(
  String url, {
  Map<String, dynamic>? data,
  Options? options,
  CancelToken? cancelToken,
  bool showToastError = true,
}) async {
  try {
    debugPrint('requestUri---$BaseUrl$url');
    debugPrint('params---$data');
    final Response response = await dio.get(url,
        queryParameters: data, options: options, cancelToken: cancelToken);
    debugPrint('get success---------${response.statusCode}');
    debugPrint('get success---------${response.data}');
    if (response.statusCode == 200) {
      return ResultData(
          code: response.data['code'] as int,
          message: response.data['message'],
          data: response.data['data'],
          success: true);
    }
    if (showToastError) Newstoast.showToast(msg: '请求失败');
    return ResultData.error('请求失败');
  } on DioError catch (error) {
    debugPrint('get error -------- $error');
    TokenInvalid.isTokenInvalid(error.response?.statusCode);
    if (showToastError) Newstoast.showToast(msg: _formatError(error));
    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _post(
  String url, {
  Map<String, dynamic>? data,
  Options? options,
  CancelToken? cancelToken,
  bool showToastError = true,
}) async {
  try {
    debugPrint('requestUri---$BaseUrl$url');
    debugPrint('params---$data');
    final Response response = await dio.post(url,
        data: data, options: options, cancelToken: cancelToken);
    debugPrint('requestUri ------- ${response.realUri}');
    debugPrint('requestHeader-------${response.headers}');
    debugPrint('post success---------${response.statusCode}');
    debugPrint('post success---------${response.data}');
    if (response.statusCode == 200) {
      var mapData;
      if (response.data is String) {
        mapData = json.decode(response.data);
      } else {
        mapData = response.data;
      }
      return ResultData(
        success: true,
        data: mapData['data'],
        message: mapData['message'].toString(),
        code: mapData['code'] as int,
      );
    }
    if (showToastError) Newstoast.showToast(msg: '请求失败');
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
    TokenInvalid.isTokenInvalid(error.response?.statusCode);
    if (showToastError) Newstoast.showToast(msg: _formatError(error));
    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _put(
  String url, {
  Map<String, dynamic>? data,
  Options? options,
  CancelToken? cancelToken,
  bool showToastError = true,
}) async {
  try {
    debugPrint('requestUri---$BaseUrl$url');
    debugPrint('params---$data');
    final Response response = await dio.put(url,
        data: data, options: options, cancelToken: cancelToken);
    debugPrint('requestUri ------- ${response.realUri}');
    debugPrint('requestHeader-------${response.headers}');
    debugPrint('post success---------${response.statusCode}');
    debugPrint('post success---------${response.data}');
    if (response.statusCode == 200) {
      var mapData;
      if (response.data is String) {
        mapData = json.decode(response.data);
      } else {
        mapData = response.data;
      }
      return ResultData(
        success: true,
        data: mapData['data'],
        message: mapData['message'].toString(),
        code: mapData['code'] as int,
      );
    }
    if (showToastError) Newstoast.showToast(msg: '请求失败');
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
    TokenInvalid.isTokenInvalid(error.response?.statusCode);
    if (showToastError) Newstoast.showToast(msg: _formatError(error));
    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _delete(
  String url, {
  Map<String, dynamic>? data,
  Options? options,
  CancelToken? cancelToken,
  bool showToastError = true,
}) async {
  try {
    debugPrint('requestUri---$BaseUrl$url');
    debugPrint('params---$data');
    final Response response = await dio.delete(url,
        data: data, options: options, cancelToken: cancelToken);
    debugPrint('requestUri ------- ${response.realUri}');
    debugPrint('requestHeader-------${response.headers}');
    debugPrint('post success---------${response.statusCode}');
    debugPrint('post success---------${response.data}');
    if (response.statusCode == 200) {
      var mapData;
      if (response.data is String) {
        mapData = json.decode(response.data);
      } else {
        mapData = response.data;
      }
      return ResultData(
        success: true,
        data: mapData['data'],
        message: mapData['message'].toString(),
        code: mapData['code'] as int,
      );
    }
    if (showToastError) Newstoast.showToast(msg: '请求失败');
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
    TokenInvalid.isTokenInvalid(error.response?.statusCode);
    if (showToastError) Newstoast.showToast(msg: _formatError(error));
    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _upload(
  String url, {
  FormData? data,
  Options? options,
  CancelToken? cancelToken,
  bool showToastError = true,
}) async {
  try {
    debugPrint('requestUri---$BaseUrl$url');
    debugPrint('params---$data');
    Dio uploadDio = new Dio();
    uploadDio.options.baseUrl = BaseUrl;
    uploadDio.options.sendTimeout = TimeoutSend;
    uploadDio.options.receiveTimeout = TimeoutReceive;
    uploadDio.options.contentType = 'multipart/form-data';
    final token = UserProvider.shared.token;
    uploadDio.options.headers = {'Authorization': token};
    final Response response = await uploadDio.post(url,
        data: data, options: options, cancelToken: cancelToken);
    debugPrint('requestUri ------- ${response.realUri}');
    debugPrint('requestHeader-------${response.headers}');
    debugPrint('post success---------${response.statusCode}');
    debugPrint('post success---------${response.data}');
    if (response.statusCode == 200) {
      var mapData;
      if (response.data is String) {
        mapData = json.decode(response.data);
      } else {
        mapData = response.data;
      }
      return ResultData(
        success: true,
        data: mapData['data'],
        message: mapData['message'].toString(),
        code: mapData['code'] as int,
      );
    }
    if (showToastError) Newstoast.showToast(msg: '请求失败');
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
    TokenInvalid.isTokenInvalid(error.response?.statusCode);
    if (showToastError) Newstoast.showToast(msg: _formatError(error));
    return ResultData.error(_formatError(error));
  }
}

class Api {
  // 初始化
  static void initAPI() {
    dio.options.baseUrl = BaseUrl;
    dio.options.sendTimeout = TimeoutSend;
    dio.options.receiveTimeout = TimeoutReceive;

    /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
    /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
    /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
    /// 就会自动编码请求体.
    // dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.contentType = Headers.jsonContentType;
  }

  static void setAuthHeader(String token) {
    dio.options.headers = {
      'Authorization': token,
    };
  }

  /// 获取验证码
  static Future<ResultData> getCheckCode(
          {String? mobile, bool showToastError = true}) =>
      _get('/checkcode',
          data: {'mobile': mobile}, showToastError: showToastError);

  /// 验证验证码
  static Future<ResultData> checkCodeVerify(
          {String? code, bool showToastError = true}) =>
      _post('/checkcode/verify',
          data: {'code': code}, showToastError: showToastError);

  /// 验证码登陆
  static Future<ResultData> loginWithPin(
          {String? mobile, String? pin, bool showToastError = true}) =>
      _post('/login/pin',
          data: {
            'mobile': mobile,
            'pin': pin,
          },
          showToastError: showToastError);

  /// 密码登陆
  static Future<ResultData> loginWithPassword(
          {String? mobile, String? password, bool showToastError = true}) =>
      _post('/login/password',
          data: {'mobile': mobile, 'password': password},
          showToastError: showToastError);

  /// 获取用户资料
  static Future<ResultData> getUserInfo(
          {String? userid, bool showToastError = true}) =>
      _get('/user/info',
          data: {'user': userid}, showToastError: showToastError);

  /// 更新用户资料
  static Future<ResultData> updateUserInfo(
      {int? sex,
      String? nickname,
      String? avatar,
      bool showToastError = true}) {
    Map<String, dynamic> _data = {};
    if (sex != null) {
      _data['sex'] = sex;
    }
    if (nickname != null) {
      _data['nickname'] = nickname;
    }
    if (avatar != null) {
      _data['avatar'] = avatar;
    }
    return _put('/user/update', data: _data, showToastError: showToastError);
  }

  /// 忘记密码
  static Future<ResultData> setNewPassword(
          {String? mobile, String? password, bool showToastError = true}) =>
      _post('/user/forget/password',
          data: {
            'mobile': mobile,
            'password': password,
            're_password': password
          },
          showToastError: showToastError);

  /// 设置密码
  static Future<ResultData> setPassword(String password,
          {bool showToastError = true}) =>
      _post('/user/password',
          data: {'password': password, 're_password': password},
          showToastError: showToastError);

  /// 获取自己关注的用户
  static Future<ResultData> getUserFavouriteList(
          {bool showToastError = true}) =>
      _get('/user/favourite/list', showToastError: showToastError);

  /// 关注用户
  /// status是否关注, 默认 true, 传 false 则取消关注
  static Future<ResultData> changeUserFavourite(
      {String? followeduserid, bool? status, bool showToastError = true}) {
    bool _status = status ?? true;
    return _put('/user/favourite',
        data: {'followed_user': followeduserid, 'status': _status},
        showToastError: showToastError);
  }

  /// 获取自己关注的文章
  static Future<ResultData> getUserFavouritePost(
          {bool showToastError = true}) =>
      _get('/user/favourite/post', showToastError: showToastError);

  /// 接口的小标题信息
  static Future<ResultData> getHomeInfo() => _get('/');

  /// 获取首页banners
  static Future<ResultData> getPostBanners({bool showToastError = true}) =>
      _get('/post/banner', showToastError: showToastError);

  /// 获取文章列表
  static Future<ResultData> getPosts(
          {int page = 1, int perpage = 10, bool showToastError = true}) =>
      _get('/post/list?page=$page&per_page=$perpage',
          showToastError: showToastError);

  /// 获取文章详情
  static Future<ResultData> getPostDetail(String postid,
          {bool showToastError = true}) =>
      _get('/post/$postid', showToastError: showToastError);

  /// 收藏文章
  static Future<ResultData> favoritePost(
          {String? postid, bool status = true, bool showToastError = true}) =>
      _put('/post/favourite',
          data: {'post': postid, 'status': status},
          showToastError: showToastError);

  /// 是否收藏了该文章
  static Future<ResultData> getFavouritePost(
          {String? id, bool showToastError = true}) =>
      _get('/post/favourite/$id', showToastError: showToastError);

  /// 点赞文章
  static Future<ResultData> thumbupPost(
          {String? post, bool status = true, bool showToastError = true}) =>
      _put('/post/thumbup',
          data: {'post': post, 'status': status},
          showToastError: showToastError);

  /// 是否点赞了该文章
  static Future<ResultData> getThumpubPost(
          {String? id, bool showToastError = true}) =>
      _get('/post/thumbup/$id', showToastError: showToastError);

  /// 文章评论列表
  static Future<ResultData> getCommentList(
          {int page = 1,
          int perpage = 10,
          String? postid,
          bool showToastError = true}) =>
      _get('/comment/list',
          data: {'page': page, 'per_page': perpage, 'post': postid},
          showToastError: showToastError);

  /// 添加文章评论
  static Future<ResultData> addComment(
          {String? postid, String? content, bool showToastError = true}) =>
      _post('/comment/add',
          data: {'post': postid, 'content': content},
          showToastError: showToastError);

  /// 点赞(取消点赞)评论
  static Future<ResultData> commentFavourite(
          {String? comment, bool status = true, bool showToastError = true}) =>
      _post('/comment/favourite',
          data: {'comment': comment, 'status': status},
          showToastError: showToastError);

  /// 上传图片接口
  static Future<ResultData> uploadFile(
          {FormData? data, bool showToastError = true}) =>
      _upload('/file/upload', data: data, showToastError: showToastError);

  /// 创建公告对象
  static Future<ResultData> addAnnoucement(
          {String? title,
          String? subscript,
          String? content,
          bool showToastError = true}) =>
      _post('/annoucement/add',
          data: {'title': title, 'subscript': subscript, 'content': content},
          showToastError: showToastError);

  /// 获取公告
  static Future<ResultData> getNotifyList(
          {int? page = 1, int? perpage = 10, bool showToastError = true}) =>
      _get('/notify/list?page=$page&per_page=$perpage',
          showToastError: showToastError);

  /// 公告已读
  static Future<ResultData> setNotifyReaded(
          {String? id, bool showToastError = true}) =>
      _put('/notify/readed', data: {'id': id}, showToastError: showToastError);

  /// 上传反馈接口
  static Future<ResultData> feedback(
          {String? content,
          String? contact,
          List? images,
          bool showToastError = true}) =>
      _post('/feedback',
          data: {'content': content, 'contact': contact, 'images': images},
          showToastError: showToastError);

  /// 搜索文章标题
  static Future<ResultData> search(
          {int page = 1,
          int perpage = 10,
          String? key,
          bool showToastError = true}) =>
      _get('/search?page=$page&per_page=$perpage',
          data: {'key': key}, showToastError: showToastError);

  /* 圈子相关 */
  /// 创建圈子评论
  static Future<ResultData> addCommentMoment(
          {required String moment,
          required String content,
          String? reference,
          String? comment,
          bool showToastError = true}) =>
      _post('/comment_moment/add',
          data: {
            'moment': moment,
            'content': content,
            'reference': reference,
            'comment': comment,
          },
          showToastError: showToastError);

  /// 获取圈子评论列表
  static Future<ResultData> getCommentMomentList(
          {required String moment,
          int page = 1,
          int perpage = 10,
          bool showToastError = true}) =>
      _get('/comment_moment/list',
          data: {'page': page, 'perpage': perpage, 'moment': moment},
          showToastError: showToastError);

  /// 点赞圈子评论
  static Future<ResultData> changeCommentMomentFavourite(
          {required String commentID,
          bool? status,
          bool showToastError = true}) =>
      _post('/comment_moment/favourite',
          data: {
            'comment': commentID,
            'status': status,
          },
          showToastError: showToastError);

  /// 创建圈子列表
  static Future<ResultData> addMoment(
          {required String title,
          required String content,
          required List<String> visibles,
          List<String>? images,
          bool showToastError = true}) =>
      _post('/moment/add',
          data: {
            'title': title,
            'content': content,
            'visibles': visibles,
            'images': images,
          },
          showToastError: showToastError);

  /// 获取圈子列表
  static Future<ResultData> getMomentList(
          {int page = 1, int perpage = 10, bool showToastError = true}) =>
      _get('/moment/list?page=$page&per_page=$perpage',
          showToastError: showToastError);

  /// 获取圈子详情
  static Future<ResultData> getMomentDetail(
          {required String id, bool showToastError = true}) =>
      _get('/moment/$id', showToastError: showToastError);

  /// 收藏圈子
  static Future<ResultData> changeMomentFavourite(
          {required String moment, bool? status, bool showToastError = true}) =>
      _put('/moment/favourite',
          data: {'moment': moment, 'status': status},
          showToastError: showToastError);

  /// 点赞圈子
  static Future<ResultData> changeMomentThumbup(
          {required String moment, bool? status, bool showToastError = true}) =>
      _put('/moment/thumbup',
          data: {'moment': moment, 'status': status},
          showToastError: showToastError);

  /// 是否点赞圈子
  static Future<ResultData> getMomentThumbup(
          {required String moment, bool showToastError = true}) =>
      _get('/moment/thumbup/$moment', showToastError: showToastError);

  /// 是否收藏圈子
  static Future<ResultData> getMomentFavourite(
          {required String moment, bool showToastError = true}) =>
      _get('/moment/favourite/$moment', showToastError: showToastError);

  /// 搜索圈子
  static Future<ResultData> searchMoment(
          {int page = 1,
          int perpage = 20,
          String? key,
          bool showToastError = true}) =>
      _get('/search/moment?key=$key&page=$page&per_page=$perpage',
          showToastError: showToastError);

  /// 搜索圈子热门
  static Future<ResultData> searchMomentHot({bool showToastError = true}) =>
      _get('/search/moment/hot', showToastError: showToastError);

  /// 更新圈子
  static Future<ResultData> updateMoment(
          {required String moment,
          String? title,
          String? content,
          required List<String> visibles,
          List<String>? images,
          bool showToastError = true}) =>
      _put('/moment/update',
          data: {
            'moment': moment,
            'title': title,
            'content': content,
            'visibles': visibles,
            'images': images,
          },
          showToastError: showToastError);

  ///删除圈子
  static Future<ResultData> deleteMoment(
          {required String moment, bool showToastError = true}) =>
      _delete('/moment/delete',
          data: {'moment': moment}, showToastError: showToastError);
}
