import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:miscrm/config.dart';
import 'package:miscrm/home/models/models.dart';
import 'package:miscrm/home/repositories/user_repository.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final UserRepository userRepository=new UserRepository();

  @override
  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {

    if (event is FetchUserDetail){

        try {
          dynamic responseData = await userRepository.getUserDetail(event.token);
          switch (responseData["code"]){
            case 302:
              yield UserDetailError(msg: "登录过期，请关闭app重新登录");
              break;
            case 404:
              yield UserDetailError(msg: "网络异常");
              break;
            case 0:
              //请求成功，响应代码为0，成功获取用户信息
              final User user = User.fromJson(responseData);
              yield UserDetailLoaded(user: user);
              break;
            default :
              yield UserDetailError(msg: "请求出现未知错误...");
              break;
          }
          /*if (responseData['msg'] != null){
            yield UserDetailError(msg: responseData['msg']);
          }else{
            final User user = User.fromJson(responseData);
            yield UserDetailLoaded(user: user);
          }
*/
        }catch (e){
          throw Exception('异常错误:$e');
        }

    }

    if(event is UpdateUserDetail){
      try {
        dynamic responseData = await userRepository.updateUserDetail(changeInfo: event.changeInfo, token: event.token);
        switch (responseData['code']){
          case 302:
            yield UpdateUserFail(msg: "登录过期，请关闭app重新登录");
            break;
          case 404:
            yield UpdateUserFail(msg: "网络异常");
            break;
          case 500:
            yield UpdateUserFail(msg: responseData["msg"]);
            break;
          case 0:
            //更新成功，没有接收到错误信息，则重新获取用户信息并修改本地profile
            dynamic userDataResponse = await userRepository.getUserDetail(myToken);
            if(userDataResponse['code'] != 0){
              print("更新后获取用户数据失败");
            }else{
              User user = User.fromJson(userDataResponse);
              profile.user = user;
              yield UpdateUserSuccess();
            }
            break;
          default:
          yield UpdateUserFail(msg: "请求出现未知错误...");
        }
      }catch (e){
        print(e);
      }
    }
  }
}
