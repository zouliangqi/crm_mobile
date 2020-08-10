import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:miscrm/login/user_repository.dart';
import 'package:miscrm/login/authen_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;


  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try{
        Map res=await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if(res["code"]==0){
          authenticationBloc.add(LoggedIn(token: res["token"]));
          yield LoginInitial();
        }else if(res["code"]==500){
          yield LoginFailure(error: res["msg"]);
        }else if(res["code"]==502){
          print("密码过期");
          BotToast.showText(text: "密码过期，请更新密码",align: Alignment.center);
          authenticationBloc.add(UpdatePassword());
        }
        else{
          yield LoginFailure(error: res["msg"]);
        }
      }catch(e){
        yield LoginFailure(error: "网络异常");
      }
    }

  }
}


//event
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}


//class RegisterButtonPressed extends LoginEvent{
//  const RegisterButtonPressed();
//
//  @override
//  List<Object> get props =>[];
//
//}




//state
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}

//class RegisterStart extends LoginState{}
//
//class Registering extends LoginState{}
//
//class Registered extends LoginState{}
//
//class RegisterFail extends LoginState{}
