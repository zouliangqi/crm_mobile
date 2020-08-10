import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:miscrm/config.dart';
import 'package:miscrm/login/pages/data.dart';
import 'package:miscrm/routers/application.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miscrm/login/user_repository.dart';
import 'package:miscrm/login/authen_bloc.dart';
class ChangePwdBloc extends Bloc<ChangePwdEvent, ChangePwdState> {
  final AuthenticationBloc authenticationBloc;
  ChangePwdBloc({

    @required this.authenticationBloc,
  })  : assert(authenticationBloc != null);

  @override
  ChangePwdState get initialState => ChangePwdInitial();

  @override
  Stream<ChangePwdState> mapEventToState(ChangePwdEvent event) async* {
    if (event is ChangePwdInit) {
     // await changePwdRepository.registerGetUser();
      //  var dept= await registerRepository.registerGetDept();
      yield ChangePwdLoading();

    }
    else if(event is ChangePwdButtonPressed){
      yield ChangePwdLoading();

      await Future.delayed(Duration(milliseconds: 500));
      F f=F();
      Map response=await f.changePwd(password1: event.password1, password2: event.password2);



      if(response["code"]==500){

        yield ChangePwdFailure(error: response["msg"]);
      }
      else if(response["code"]==0) {
        yield ChangePwdSuccess(success: "修改成功");
      }else if(response["code"]==302){
        yield ChangePwdFailure(error: "登录过期,请关闭app重新登录");
      }
      else {
          yield ChangePwdFailure(error: response["msg"]);
      }
    }

    else if(event is ChangePwdButtonPressed2){
      yield ChangePwdLoading();

      await Future.delayed(Duration(milliseconds: 500));
      F f=F();
      Map response=await f.updatePwd(password1: event.password1, password2: event.password2);



      if(response["code"]==500){

        yield ChangePwdFailure(error: response["msg"]);
      }
      else if(response["code"]==0) {
        authenticationBloc.add(UpdatePasswordSuccess());
        BotToast.showText(text: "密码修改成功",align: Alignment.center);
       // yield ChangePwdSuccess(success: "修改成功");

      }else if(response["code"]==302){
        yield ChangePwdFailure(error: "登录过期,请关闭app重新登录");
      }
      else {
        yield ChangePwdFailure(error: response["msg"]);
      }
    }
    else if(event is ForgetPwdButtonPressed){
      yield ChangePwdLoading();

      await Future.delayed(Duration(milliseconds: 500));
      F f=F();
      Map response=await f.forgetPassword(event.userCode, event.mobile);
      print(response["code"].toString());


      if(response["code"]==500){

        yield ChangePwdFailure(error: response["msg"]);
      }
      else if(response["code"]==0) {
        yield ChangePwdSuccess(success: response["msg"].toString());
      }else if(response["code"]==302){
        yield ChangePwdFailure(error: "登录过期,请关闭app重新登录");
      }
      else {
        yield ChangePwdFailure(error: response["msg"]);
      }
    }
  }
}

//event
abstract class ChangePwdEvent extends Equatable {
  const ChangePwdEvent();
}



class ChangePwdButtonPressed extends ChangePwdEvent{
  final String password1;
  final String password2;



  const ChangePwdButtonPressed({
    @required this.password1,
    @required this.password2,


  });



  @override
  List<Object> get props => [password1,password2];

}
class ChangePwdButtonPressed2 extends ChangePwdEvent{
  final String password1;
  final String password2;



  const ChangePwdButtonPressed2({
    @required this.password1,
    @required this.password2,


  });



  @override
  List<Object> get props => [password1,password2];

}

class ForgetPwdButtonPressed extends ChangePwdEvent{
  final String userCode;
  final String mobile;

  const ForgetPwdButtonPressed({
    @required this.userCode,
    @required this.mobile,
  });
  @override
  List<Object> get props => [userCode,mobile];

}

class ChangePwdInit extends ChangePwdEvent{
  final String kk;
  const ChangePwdInit({this.kk});

  @override
  List<Object> get props =>[kk];
}

//state
abstract class ChangePwdState extends Equatable {
  const ChangePwdState();

  @override
  List<Object> get props => [];
}


class ChangePwdInitial extends ChangePwdState {}

class ChangePwdLoading extends ChangePwdState {}

class ChangePwdSuccess extends ChangePwdState {
  final String success;

  const ChangePwdSuccess({@required this.success});

  @override
  List<Object> get props => [success];

  @override
  String toString() => 'ChangePwdSuccess { success: $success }';
}
class ChangePwdFailure extends ChangePwdState {
  final String error;

  const ChangePwdFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ChangePwdFailure { error: $error }';
}


class F {

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
      var baseUrl = api + "/system/user/updatePassword";
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

  Future<Map> forgetPassword(userCode,mobile) async {
    try {
      var d = {
        "userCode": userCode,
        "mobile": mobile,
      };

      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/forgetPassword";

      dio.options.contentType = Headers.formUrlEncodedContentType;
      dio.options.headers["Origin"] = 'http://45.40.235.233';
      var response;
      response = await dio.post(baseUrl, data: d);

      if (response.data["code"] == 500) {
        BotToast.showText(text: response.data["msg"], align: Alignment.center);
        return response.data;
      } else if (response.data["code"] == 302) {
        BotToast.showText(text: "登录过期请重新登录", align: Alignment.center);
        return {"code": 500, "msg": "登录过期请重新登录"};
      } else {
        //print(response.data);
        return response.data;
      }
    } catch (e) {
      BotToast.showText(text: "网络异常", align: Alignment.center);
      return {"code": 500, "msg": "网络异常"};
    }
  }


  //更新密码
  Future<Object> updatePwd({
    @required String password1,
    @required String password2,
  }) async {
    var d = {
      'userCode':userCode,
      'oldPwd': password1,
      'newPwd': password2,

    };
    try {
      Dio dio = new Dio();

      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/updatePassword";
      dio.options.contentType = Headers.formUrlEncodedContentType;

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
}