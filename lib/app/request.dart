import 'dart:io';
import 'package:dio/dio.dart';

import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class Request {
  
  static const String baseUrl = 'http://www.shuqi.com/';

  static Future<dynamic> get({String action,Map params}) async {
    //模拟虚拟数据
    return Request.mock(action:action, params:params);

    // 网络数据请求
    // var dio =Request.createDio();
    // Response response =await dio.get(action,data:params);
    // var data =response.data['data'];
    // return data;

  }

  static Future<dynamic> post({String action, Map params}) async {
    //模拟虚拟数据
    return Request.mock(action: action, params: params);

    //网络数据请求
    // var dio =Request.createDio();
    // Response response =await dio.post(action, data:params);
    // var data =response.data['data'];
    // print(data);
    // return data;
    
  }

  static Future<dynamic> mock({String action, Map params}) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    print(responseJson['data']);
    return responseJson['data'];
  }

  static Dio createDio() {
    var options =Options(
      baseUrl: baseUrl,
      connectTimeout:  10000,
      receiveTimeout:  100000,
      contentType:  ContentType.json
    );
    return Dio(options);
  }

}