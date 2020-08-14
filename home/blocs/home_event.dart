import 'package:equatable/equatable.dart';
import 'package:miscrm/home/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchUserDetail extends HomeEvent {

  final String token;
  FetchUserDetail({@required this.token}) : assert(token != null);
//  SharedPreferences preferences = await SharedPreferences.getInstance();
//  preferences.get("token");
  @override
  List<Object> get props => null;

}

class UpdateUserDetail extends HomeEvent{
  final Map changeInfo;
  final String token;

  UpdateUserDetail({@required this.changeInfo,@required this.token});


  @override
  List<Object> get props => [changeInfo,token];


}
