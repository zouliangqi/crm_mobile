
import 'dart:math';

import 'package:miscrm/config.dart';
import 'package:dio/dio.dart';
import 'package:miscrm/home/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miscrm/config.dart';

class UserRepository {

  UserRepository();

  Future getUserDetail (String token) async {
    Response response;
    Dio dio = new Dio();
    dio.options.headers = {'Admin-Token':token};

    try{
      response = await dio.post(api+'/system/user/queryLoginUser');
      //print("response是:$response");
      //print("response.data是：${response.data}");

        return response.data;

    } catch (e){
      print(e);
      return {
        "code":404,
        "msg":"网络异常"
      };
    }
  }

  Future getUserToken () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.get("token") == null){
      myToken = preferences.get("token");
      print('持久化中获取并重新赋值Mytoken : $myToken');
      return myToken;
    }else{
      return 'No token get';
    }
  }

  Future updateUserDetail({changeInfo, token}) async{


    Map<String,dynamic> reqData = {
      "username": profile.user.username,
      //"realname": profile.user.realname,
    };

    //获取已经修改了个人信息的map集合
    changeInfo.forEach((k, v){

      switch (k){
        //当传递修改的Map集合有sex关键字时，要将字符串映射成整数int
        case "sex":
          print('I change the value of $k to $v');
          if (changeInfo[k]=="男"){
            v = 1;
            reqData['realname'] = profile.user.realname;
            reqData[k] = v;//将更改后的 k-v 赋值到请求数据中
          }else if(changeInfo[k]=="女"){
            v = 2;
            reqData['realname'] = profile.user.realname;
            reqData[k] = v;
          }else{
            v = 0;
            reqData['realname'] = profile.user.realname;
            reqData[k] = v;
          }
          break;
        case "realname":
          print('I change the value of $k to $v');
          reqData[k] = v;
          break;
        default:
          reqData['realname'] = profile.user.realname;//默认情况下没有修改realname则在请求数据里面加上，否则不能调用接口修改用户数据
          reqData[k] = v;
      }
    });
    print("更改用户信息接口的post请求数据 == > $reqData");
    Response response;

    try{
      Dio dio = new Dio();
      dio.options.headers = {"Admin-Token":token};
      dio.options.contentType = Headers.formUrlEncodedContentType;
      response = await dio.post(api+"/system/user/updateUser", data: reqData);
      //print("Update and respone is $response");

      return response.data;

    }catch (e){
      print(e);
      return {
        "code":404,
        "msg":"网络异常"
      };
    }
  }
}