import 'package:dio/dio.dart';
import 'package:miscrm/config.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import "package:flutter/widgets.dart";
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OaRecord2Repository {



  //日程列表
  Future<Map> getOaRecordPageList2(pageIndex) async {
    try {
      var d = {"type": 2, "page": pageIndex, "limit": 5};
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/OaRecord/getOaRecordPageList";
      dio.options.contentType = Headers.formUrlEncodedContentType;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dio.options.headers["Admin-token"] = preferences.get("token");
      var response;
      response = await dio.post(baseUrl, data: d);
      //print(response.data);
      if (response.data["code"] == 500) {
        BotToast.showText(text: response.data["msg"], align: Alignment.center);
        return response.data;
      } else if (response.data["code"] == 302) {
        BotToast.showText(text: "登录过期请重新登录", align: Alignment.center);
        return {"code": 500, "msg": "登录过期请重新登录"};
      } else {

        return response.data;
      }
    } catch (e) {
      BotToast.showText(text: "网络异常", align: Alignment.center);
      return {"code": 500, "msg": "网络异常"};
    }
  }




}