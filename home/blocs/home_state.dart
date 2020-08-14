import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:miscrm/home/models/models.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class InitialHomeState extends HomeState {

}
//获取用户信息加载中
class UserDetailLoading extends HomeState {}
//成功获取用户信息，加载完成
class UserDetailLoaded extends HomeState {

  final User user;

  const UserDetailLoaded({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}
//获取用户信息错误
class UserDetailError extends HomeState {
  final String msg;

  const UserDetailError({@required this.msg}) : assert(msg != null);

  @override
  List<Object> get props => [msg];

}

//class UpdateUser extends HomeState{
//
//}
//成功更新用户信息
class UpdateUserSuccess extends HomeState{}
//更新用户信息失败
class UpdateUserFail extends HomeState{
  final msg;

  const UpdateUserFail({@required this.msg}) : assert(msg != null);
}