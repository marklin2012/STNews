import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:stnews/providers/user_provider.dart';
import 'package:stnews/service/result_data.dart';

const TimeoutConnect = 5000;
const TimeoutReceive = 8000;
const TimeoutSend = 3000;

// ignore: non_constant_identifier_names
String BaseUrl = Platform.isAndroid
    ? 'http://192.168.2.116:7001/'
    : 'http://localhost:7001/';
// const String BaseUrl = 'http://localhost:7001/';
// const String BaseUrl = 'http://192.168.2.110:7001/';
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

Future<ResultData> _get(String url,
    {Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken}) async {
  try {
    debugPrint('requestUri---$url');
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
    return ResultData.error('请求失败');
  } on DioError catch (error) {
    debugPrint('get error -------- $error');

    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _post(
  String url, {
  Map<String, dynamic>? data,
  Options? options,
  CancelToken? cancelToken,
}) async {
  try {
    debugPrint('requestUri---$url');
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
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _put(String url,
    {Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken}) async {
  try {
    debugPrint('requestUri---$url');
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
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
    return ResultData.error(_formatError(error));
  }
}

Future<ResultData> _upload(
  String url, {
  FormData? data,
  Options? options,
  CancelToken? cancelToken,
}) async {
  try {
    debugPrint('requestUri---$url');
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
    return ResultData.error('请求异常');
  } on DioError catch (error) {
    debugPrint('post error -------- $error');
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
  static Future<ResultData> getCheckCode({String? mobile}) =>
      _get('/checkcode', data: {'mobile': mobile});

  /// 验证验证码
  static Future<ResultData> checkCodeVerify({String? code}) =>
      _post('/checkcode/verify', data: {'code': code});

  /// 验证码登陆
  static Future<ResultData> loginWithPin({String? mobile, String? pin}) =>
      _post('/login/pin', data: {
        'mobile': mobile,
        'pin': pin,
      });

  /// 密码登陆
  static Future<ResultData> loginWithPassword(
          {String? mobile, String? password}) =>
      _post('/login/password', data: {'mobile': mobile, 'password': password});

  /// 获取用户资料
  static Future<ResultData> getUserInfo({String? userid}) =>
      _get('/user/info', data: {'user': userid});

  /// 更新用户资料
  static Future<ResultData> updateUserInfo(
      {int? sex, String? nickname, String? headImage}) {
    Map<String, dynamic> _data = {};
    if (sex != null) {
      _data['sex'] = sex;
    }
    if (nickname != null) {
      _data['nickname'] = nickname;
    }
    if (headImage != null) {
      _data['head_image'] = headImage;
    }
    return _put('/user/update', data: _data);
  }

  /// 设置密码
  static Future<ResultData> setPassword(String password) =>
      _post('/user/password',
          data: {'password': password, 're_password': password});

  /// 获取自己关注的用户
  static Future<ResultData> getUserFavouriteList() =>
      _get('/user/favourite/list');

  /// 关注用户
  /// status是否关注, 默认 true, 传 false 则取消关注
  static Future<ResultData> changeUserFavourite(
      {String? followeduserid, bool? status}) {
    bool _status = status ?? true;
    return _put('/user/favourite',
        data: {'followed_user': followeduserid, 'status': _status});
  }

  /// 获取自己关注的文章
  static Future<ResultData> getUserFavouritePost() =>
      _get('/user/favourite/post');

  /// 接口的小标题信息
  static Future<ResultData> getHomeInfo() => _get('/');

  /// 获取文章列表
  static Future<ResultData> getPosts({int page = 1, int perpage = 10}) =>
      _get('/post/list?page=$page&per_page=$perpage');

  /// 获取文章详情
  static Future<ResultData> getPostDetail(String postid) =>
      _get('/post/$postid');

  /// 收藏文章
  static Future<ResultData> favoritePost(
          {String? postid, bool status = true}) =>
      _put('/post/favourite', data: {'post': postid, 'status': status});

  /// 点赞文章
  static Future<ResultData> thumbupPost({String? post, bool status = true}) =>
      _put('/post/thumbup', data: {'post': post, 'status': status});

  /// 是否点赞了该文章
  static Future<ResultData> getThumpubPost({String? id}) =>
      _get('/post/thumbup/$id');

  /// 文章评论列表
  static Future<ResultData> getCommentList(
          {int page = 1, int perpage = 10, String? postid}) =>
      _get('/comment/list',
          data: {'page': page, 'per_page': perpage, 'post': postid});

  /// 添加文章评论
  static Future<ResultData> addComment({String? postid, String? content}) =>
      _post('/comment/add', data: {'post': postid, 'content': content});

  /// 点赞(取消点赞)评论
  static Future<ResultData> commentFavourite(
          {String? comment, bool status = true}) =>
      _post('/comment/favourite', data: {'comment': comment, 'status': status});

  /// 上传图片接口
  static Future<ResultData> uploadFile({FormData? data}) =>
      _upload('/file/upload', data: data);
}
