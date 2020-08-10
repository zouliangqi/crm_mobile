import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:miscrm/config.dart';
class UserRepository {
  Future<Map> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return login(username,password);
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    myToken=token;
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.get("token") != null){
      //验证token有效性
      var d = {
        'Admin-Token': preferences.get("token") ,
      };
      try {
        Dio dio = new Dio(); //
        dio.options.connectTimeout = 5000;
        var baseUrl = api+"/checkToken";
        dio.options.contentType = Headers.formUrlEncodedContentType;
        var response;
        response = await dio.post(
          baseUrl,
          data: d,
        );
        if(response.data["code"]==0) {
          //BotToast.showText(text: response.data["msg"],align:Alignment.center);
          return true;
        }else if(response.data["code"]==500){
          BotToast.showText(text: "登录已过期，请重新登录",align:Alignment.center);
          return false;
        }else {
          BotToast.showText(text: "登录已过期，请重新登录",align:Alignment.center);
          return false;
        }

      }catch(e){
        BotToast.showText(text: "网络异常",align:Alignment.center);
        return false;
      }

      return true;
    }else{
      return false;
    }
  }







  //保存用户名和密码
  void _saveLoginMsg(username,password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("name", username);
    preferences.setString("pwd", password);

  }

//  //修改密码/system/user/updatePassword
//  Future<String> changePassword(username,password)async {
//    var d = {
//      'userCode': username,
//      'userPwd': password,
//    };
//
//    try {
//      Dio dio = new Dio(); //
//      var baseUrl = api+"/login";
//      dio.options.contentType = Headers.formUrlEncodedContentType;
//      var response;
//      response = await dio.post(
//        baseUrl,
//        data: d,
////        options: new Options(
////          // contentType:ContentType.parse("application/x-www-form-urlencoded"),
////        ),
//      );
//      if(response.data["code"]==500) {
//        return "500"+response.data["msg"];
//      }
//      else if(response.data["code"]==0) {
//        _saveLoginMsg(username, password);
//        User = response.data["user"];
//        return response.data["Admin-Token"];
//      }
//      else
//        return "302登录已过期，请重新登录";
//    } catch (e) {
//      return "error";
//    }
//  }


  //修改密码
  Future<Object> changePwd({
    @required String password1,
    @required String password2,
  }) async {
    var d = {
      'oldPwd': password1,
      'newPwd': password2,

    };
    try {
      Dio dio = new Dio();

      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/updatePassword";
      dio.options.contentType = Headers.formUrlEncodedContentType;

      SharedPreferences preferences = await SharedPreferences.getInstance();
      dio.options.headers["Admin-token"]=preferences.get("token");
      var response;
      response = await dio.post(
          baseUrl,
          data: d
      );
      print(response);


      return response.data;
    } catch (e) {
      return {"code": 500, "msg": "请检查网络"};
    }
  }



  //登录
  Future<Map> login(username,password)async {
    var d = {
      'userCode': username,
      'userPwd': password,
    };

    try {
      Dio dio = new Dio(); //
      dio.options.connectTimeout = 5000;
      var baseUrl = api+"/login";
      dio.options.contentType = Headers.formUrlEncodedContentType;
      var response;
      response = await dio.post(
        baseUrl,
        data: d,
//        options: new Options(
//          // contentType:ContentType.parse("application/x-www-form-urlencoded"),
//        ),
      );
//      if(response.data["code"]==500) {
////        return "500"+response.data["msg"];
////      }
////      _saveLoginMsg(username,password);
////      User=response.data["user"];
////      return response.data["Admin-Token"];

    if(response.data["code"]==0){
      _saveLoginMsg(username,password);
     // User=response.data["user"];
      return {
        "code":0,
        "msg":"登录成功",
        "token":response.data["Admin-Token"]
      };
    }
    else if(response.data["code"]==500){
      return response.data;
    }
    else{
      return response.data;
    }
    } catch (e) {
      return {
        "code":500,
        "msg":"网络异常",
      };
    }
  }

  //退出
  Future<Map> exit()async{
    try {
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/logout";
      dio.options.contentType = Headers.formUrlEncodedContentType;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dio.options.headers["Admin-token"] = preferences.get("token");
      var response;
      response = await dio.post(
        baseUrl,
      );
      print(response);
      if(response.data["code"]==0){

        //BotToast.showText(text: "已经退出登录", align: Alignment.center);
        return response.data;
      }else if(response.data["code"]==500){
        //BotToast.showText(text: response.data["msg"], align: Alignment.center);
        return response.data;
      }
      else{
       // BotToast.showText(text: response.data["msg"], align: Alignment.center);
        return {
          "code":500,
          "msg":response.data["msg"]
        };
      }

    }catch(e){
    //  Future.delayed(Duration(seconds: 5));
     // BotToast.showText(text: "网络异常", align: Alignment.center);
      return {
        "code": 500,
        "msg":"网络异常"
      };
    }
  }

  //修改密码成功，重新登录
  Future<void> relogin()async{
    Dio dio=new Dio();
    dio.options.connectTimeout = 5000;
    var baseUrl = api+"/logout";
    dio.options.contentType = Headers.formUrlEncodedContentType;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dio.options.headers["Admin-token"]=preferences.get("token");
    var response;
    response = await dio.post(
      baseUrl,
    );
    //print(response);
    BotToast.showText(text:"请重新登录",align:Alignment.center);
  }


  //忘记密码
  Future<void> forgetPassword()async{

    var d={};
    Dio dio=new Dio();
    dio.options.connectTimeout = 5000;
    var baseUrl = api+"";
    dio.options.contentType = Headers.formUrlEncodedContentType;
    var response;
    response = await dio.post(
      baseUrl,
      data: d
    );
    print(response);
    BotToast.showText(text:"修改密码成功",align:Alignment.center);
  }


}

