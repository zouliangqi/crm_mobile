import 'package:dio/dio.dart';
import 'package:miscrm/config.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
class RegisterRepository {

  //注册时根据工号带出姓名
  Future<Map> registerGetName(username)async{
    try {
      var d = {
        'username': username,
      };
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/system/step/queryUserName";
      dio.options.contentType = Headers.formUrlEncodedContentType;

      var response;
      response = await dio.post(
          baseUrl,
          data: d
      );
      print("###### 1 ######");
      print(response);
      return response.data;
    }catch(e){
      return {
        "code": 500,
        "msg": "网络异常"
      };
    }
  }

  //注册时查询直属上级
  Future<List> registerGetUser()async{
    try {
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/system/step/queryUser";
      dio.options.contentType = Headers.formUrlEncodedContentType;

      var response;
      response = await dio.get(
        baseUrl,
      );

      if (response.data['code'] == 0) {
        List d= response.data['data'];
        return d;
      }
      else if (response.data['code'] == 500) {
        BotToast.showText(text: response.data['msg'],align:Alignment.center);
        return null;
      }
      else {
        BotToast.showText(text: response.data['msg'],align:Alignment.center);
        return null;
      }
    }catch(e){
      BotToast.showText(text: "网络异常",align:Alignment.center);
      return null;
    }
  }

  //注册时查询所属部门
  Future<List> registerGetDept()async{
    try {
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;

      var baseUrl = api + "/system/step/queryDept";
      dio.options.contentType = Headers.formUrlEncodedContentType;

      var response;
      response = await dio.get(
        baseUrl,
      );
      if (response.data['code'] == 0) {

       // print(response.data);
       List d= response.data['data'];
        return d;
      }
      else if (response.data['code'] == 500) {
        BotToast.showText(text: response.data['msg'],align:Alignment.center);
        return null;
      }
      else {
        BotToast.showText(text: response.data['msg'],align:Alignment.center);
        return null;
      }
    }
    catch(e){
      BotToast.showText(text: "网络异常",align:Alignment.center);
      return null;
    }


  }


  //注册
  Future<Object> register({
    @required String username,
    @required String realname,
    @required String password,
    @required int deptId,
    @required String mobile,
    @required int sex,
    @required String email,
    @required String post,
    @required int parentId})async{
    var d={
      'username':username,
      'realname':realname,
      'password':password,
      'deptId':deptId,
      'mobile':mobile,
      'sex':sex,
      'email':email,
      'post':post,
      'parentId':parentId
    };
    try {
//      var d = {
//        'username': 'F1336855',
//        'realname': '丛小南',
//        'password': 'aa123456',
//        'deptId': 135,
//        'mobile': '13666529273',
//        'sex': 2,
//        'email': '1668706700@sina.com',
//        'post': 'aaa,',
//        'parentId': 6
//      };
      Dio dio = new Dio();

      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/system/step/register";
      dio.options.contentType = Headers.formUrlEncodedContentType;

      var response;
      response = await dio.post(
          baseUrl,
          data: d
      );
      print("###### 4 ######");
      print(response);

      return response.data;
    }catch(e){
      return {"code":500,"msg":"请检查网络"};
    }
  }

}