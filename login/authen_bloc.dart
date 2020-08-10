import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:miscrm/login/user_repository.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();
      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }
    if (event is UpdatePassword) {
      yield UpdatePwd();
    }

    if (event is UpdatePasswordSuccess){
      yield AuthenticationUnauthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
     // try {
        await userRepository.deleteToken();
        Map res=await userRepository.exit();
        if(res["code"]==0){

          yield AuthenticationUnauthenticated();
          BotToast.showText(text: "已经退出登录", align: Alignment.center);
        }else if(res["code"]==500){
          yield AuthenticationUnauthenticated();
          BotToast.showText(text: res["msg"], align: Alignment.center);

        }else{
          yield AuthenticationUnauthenticated();
          BotToast.showText(text: res["msg"], align: Alignment.center);

        }
       // yield AuthenticationUnauthenticated();

//      }catch(e){
//        BotToast.showText(text: "网络异常",align: Alignment.center);
//        yield AuthenticationUnauthenticated();
//      }
      
    }

    if(event is ReLogin){
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      await userRepository.relogin();

      yield AuthenticationUnauthenticated();
    }
  }
}

//event
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  const LoggedIn({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class UpdatePassword extends AuthenticationEvent {



  @override
  List<Object> get props => [];

  @override
  String toString() => 'UpdatePassword { token: }';
}
class UpdatePasswordSuccess extends AuthenticationEvent {



  @override
  List<Object> get props => [];

  @override
  String toString() => 'UpdatePassword { token: }';
}


class LoggedOut extends AuthenticationEvent {}

class ReLogin extends AuthenticationEvent {}





//state
abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class LogoutFail extends AuthenticationState {}

class UpdatePwd extends AuthenticationState {}
