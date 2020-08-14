/*
* 下拉列表里面 按钮数据模型
* */

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FilterButtonModel  {
  //String title; //按钮title
   Text title;
   List contents; //下拉列表
   String type; //下拉筛选类型 'Column'、'Row'
   Function callback; //按钮点击回调，可以自定义回调，如跳转页面等
   String direction; //下拉箭头方向

  FilterButtonModel({this.title, this.contents, this.type, this.callback, this.direction});


}