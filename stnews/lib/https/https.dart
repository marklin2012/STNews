import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class HttpsUtils {
  static const Timeout_Connect = 5000;
  static const Timeout_Receive = 8000;
  static const Timeout_Send = 3000;
  static const GET = 'GET';
  static const POST = 'POST';
  static const PUT = 'PUT';
  static const DELETE = 'DELETE';
}

class STHttps {
  static void _request(
    String? url,
    String method,
    Map<String, dynamic>? params,

    /// 第一个参数是网络请求错误返回的错误码
    /// 第二个参数是请求的数据
    Function? resultCallBack,
  ) async {
    String errorMsg = '';
    int statusCode;
    String _url = BASEURL;
    if (url != null) _url += url;
    try {
      Response response;
      BaseOptions baseOptions = new BaseOptions(
        /// 连接的超时时间
        connectTimeout: HttpsUtils.Timeout_Connect,

        /// 接受数据的超时时间
        receiveTimeout: HttpsUtils.Timeout_Receive,

        /// 发送请求的超时时间
        sendTimeout: HttpsUtils.Timeout_Send,
      );

      /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
      /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
      /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
      /// 就会自动编码请求体.
      Options options = new Options(
        sendTimeout: HttpsUtils.Timeout_Send,
        receiveTimeout: HttpsUtils.Timeout_Receive,
        contentType: Headers.formUrlEncodedContentType,
      );
      debugPrint("==========start============");
      debugPrint("$_url");
      Dio dio = new Dio(baseOptions);
      if (method == HttpsUtils.GET) {
        response =
            await dio.get(_url, queryParameters: params, options: options);
      } else if (method == HttpsUtils.POST) {
        response =
            await dio.post(_url, queryParameters: params, options: options);
      } else if (method == HttpsUtils.PUT) {
        response =
            await dio.put(_url, queryParameters: params, options: options);
      } else {
        response =
            await dio.delete(_url, queryParameters: params, options: options);
      }
      statusCode = response.statusCode ?? -1;
      if (statusCode != HttpStatus.ok) {
        if (resultCallBack != null) {
          resultCallBack(statusCode.toString(), null, response.statusMessage);
        }
        errorMsg = statusCode.toString() + ":" + response.statusMessage!;
        // 打印错误信息
        debugPrint("error:$errorMsg");
      } else {
        var data = json.decode(response.toString());
        if (resultCallBack != null) {
          resultCallBack(null, data, null);
        }
      }
    } catch (exception) {
      // 未知错误
      if (resultCallBack != null) {
        resultCallBack('-1', null, exception.toString());
      }
    }
    debugPrint("==========over============");
  }
}

getData({
  String? url,
  Map<String, dynamic>? params,
  Function? callBack,
}) async {
  STHttps._request(url, HttpsUtils.GET, params, callBack);
}

postData({
  String? url,
  Map<String, dynamic>? params,
  Function? callBack,
}) async {
  STHttps._request(url, HttpsUtils.POST, params, callBack);
}

putData({
  String? url,
  Function? callBack,
  Map<String, dynamic>? params,
}) async {
  STHttps._request(url, HttpsUtils.PUT, params, callBack);
}

deleteData({
  String? url,
  Function? callBack,
  Map<String, dynamic>? params,
}) async {
  STHttps._request(url, HttpsUtils.DELETE, params, callBack);
}

const BASEURL = 'http://localhost:7001/';
