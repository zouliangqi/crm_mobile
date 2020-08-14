
import 'package:dio/dio.dart';
import 'package:miscrm/home/models/profile_model.dart';
import 'package:miscrm/home/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miscrm/config.dart';


//主界面初始化方法
Future<Profile> homeInit() async{
  print("start home initialize in global's homeInit");
  Profile profile ;
  //从本地获取已经持久化的token值
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  var token;
  if(_prefs.get("token") != null){
     token = _prefs.get("token");
     //print("homeInit has token is: $token");
     Response response;
     Dio dio = new Dio();
     //dio.options.contentType = Headers.formUrlEncodedContentType;
     dio.options.headers = {'Admin-Token':token};  //给请求头添加Admin-Token字段并赋值

     try{
       response = await dio.post(api+'/system/user/queryLoginUser');
       //print(response);
       //print(response.data['data']);
       if (response.data['code']==302){
         print("msg is : ${response.data['msg']}");
         profile= Profile(msg: response.data['msg']);
         return profile;//返回错误信息字符串

       }else{
         User user = User.fromJson(response.data);//请求成功返回用户json数据生成的User实例
         profile = Profile(user: user,token: token);
         // print("实例中的token： ${profile.token}");
         return profile;//返回Profile实例
       }
     } catch (e){
       print(e);
     }

  }else{
    print('No token get') ;
  }


}