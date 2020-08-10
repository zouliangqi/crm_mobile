import 'package:flutter/material.dart';


//注册
//List<DropdownMenuItem> deptName=[];
//List deptItem;
List<DropdownMenuItem> sexName=[];
List sexItem=[
  {
    "ID":0,
    "SEX":"请选择",
  },

  {
    "ID":1,
    "SEX":"男",
  },
  {
    "ID":2,
    "SEX":"女"
  }
];
List<DropdownMenuItem> preName=[];
List preItem;
//。。

//商机
List<DropdownMenuItem> dropItem=[];
Map secne;
//。。

//公海
List<DropdownMenuItem> gongHaiDropItem=[

    new DropdownMenuItem(//margin: EdgeInsets.only(left: 100),
    child:Text("全部商机"),
    value: "全部商机",
  ),
  new DropdownMenuItem(//margin: EdgeInsets.only(left: 100),
    child:Text("我负责的商机"),
    value: "我负责的商机",
  ),
  new DropdownMenuItem(//margin: EdgeInsets.only(left: 100),
    child:Text("下属负责的商机"),
    value: "下属负责的商机",
  ),
  new DropdownMenuItem(//margin: EdgeInsets.only(left: 100),
    child:Text("我参与的商机"),
    value: "我参与的商机",
  )
];
//Map gonghaiHead;
//。。

Map gonghaifujianMap;
int data_customerId;//公海的客户id
String data_batchId;
int shangjiId;
String shangjiName;
int theCustomerId; //商机的客户id
String theCustomerName;

Map productmap;

Map getOaRecord1;
Map getOaRecord4;
Map getOaRecord2;
Map getOaRecord3;

String versioncode;

String userCode;