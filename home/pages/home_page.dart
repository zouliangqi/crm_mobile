import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miscrm/download/flutter_app_upgrade.dart';
//import 'package:flutter_app_upgrade/flutter_app_upgrade.dart';
import 'package:miscrm/home/pages/user_page.dart';
import 'package:miscrm/routers/application.dart';
import 'package:miscrm/wait_thing/the_bloc.dart';
import 'package:miscrm/wait_thing/the_event.dart';
import 'package:miscrm/wait_thing/the_page.dart';
import 'package:miscrm/wait_thing/the_reps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:miscrm/config.dart';
import 'package:miscrm/login/pages/data.dart';
import 'package:package_info/package_info.dart';

import 'OaRecord1/oaRecord1_bloc.dart';
import 'OaRecord1/oaRecord1_event.dart';
import 'OaRecord1/oaRecord1_page.dart';
import 'OaRecord1/oaRecord1_reps.dart';

import 'OaRecord2/oaRecord2_bloc.dart';
import 'OaRecord2/oaRecord2_event.dart';
import 'OaRecord2/oaRecord2_page.dart';
import 'OaRecord2/oaRecord2_reps.dart';

import 'OaRecord3/oaRecord3_bloc.dart';
import 'OaRecord3/oaRecord3_event.dart';
import 'OaRecord3/oaRecord3_page.dart';
import 'OaRecord3/oaRecord3_reps.dart';

import 'OaRecord4/oaRecord4_bloc.dart';
import 'OaRecord4/oaRecord4_event.dart';
import 'OaRecord4/oaRecord4_page.dart';
import 'OaRecord4/oaRecord4_reps.dart';

import 'package:miscrm/home/pages/sale_report/sale_bloc.dart';
import 'package:miscrm/home/pages/sale_report/sale_event.dart';
import 'package:miscrm/home/pages/sale_report/sale_page.dart';
import 'package:miscrm/home/pages/sale_report/sale_reps.dart';

import 'funnel_chart/the_bloc.dart';
import 'funnel_chart/the_event.dart';
import 'funnel_chart/the_page.dart';
import 'funnel_chart/the_reps.dart';



bool flag = false;
final oaRecord1Repository = OaRecord1Repository();
final oaRecord2Repository = OaRecord2Repository();
final oaRecord3Repository = OaRecord3Repository();
final oaRecord4Repository = OaRecord4Repository();
final saleRepository = SaleRepository();
final funnelRepository=FunnelRepository();
final waitRepository=WaitRepository();
class HomePage extends StatefulWidget {
  int newCustomer = 0;
  int newContact = 0;
  int newBusiness = 0;
  int newContract = 0;
  double contractValue = 0;
  double businessValue = 0;
  double returnMoney = 0;
  int trackingRecord = 0;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //@override
  // bool get wantKeepAlive =>true;

  String contactCustomer;
  double iconSize = 30;
  Map numMap;
  int mapnum=0;
  var _futureBuilderHome; //为了避免每次都调用FutureBuilder重建页面，所以在构建函数外面定义此变量保存Future对象，并将变量传递给FutureBuilder


  Future<AppUpgradeInfo> _checkAppInfo() async {

      Dio dio = new Dio();
      var response;
      response = await dio.get(url);

      print(response.data);
      if (response.data["version"] != versioncode) {

        return Future.delayed(Duration(seconds: 1), () {
          return AppUpgradeInfo(
            title: response.data["version"].toString(),
            contents: [
              response.data["content"].toString(),
            ],
            force: false,
            apkDownloadUrl: response.data["url"]
          );
        });

//        Future.delayed(Duration(milliseconds: 500), () {


//          showNote(
//              context, response.data["content"].toString()); //response.data["content"]
//        });
      }






  }


  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      versioncode = packageInfo.version;
    });
//    if(noteflag==false) {
//      downloadJson();
//    }

    AppUpgrade.appUpgrade(
      context,
      _checkAppInfo(),
//      iosAppId: 'id88888888',
    );
    super.initState();
    querySceneList();
    queryListHead();

    flag = true;
  }
  Future<Map> downloadJson() async {
    try {
      Dio dio = new Dio();
      var response;
      response = await dio.get(url);

      //print(response.data);
      if (response.data["version"] != versioncode) {
        Future.delayed(Duration(milliseconds: 500), () {
          showNote(
              context, response.data["content"].toString()); //response.data["content"]
        });
      }
      return response.data;
    } catch (e) {
      return {
        "code": 500,
      };
    }
  }
  showNote(context, msg) {
    showDialog(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new MessageDialog(
            //调用对话框
            title: '通知',
            message: msg.toString(),
            //negativeText: "dd",
            positiveText: '稍后提醒',
            onCloseEvent: () {
              noteFlag=true;
              Navigator.pop(context);
            },
            onPositivePressEvent: () {
              Navigator.pop(context);
            },
          );
        });
  }
  //获取公海全部表头
  queryListHead() async {
    try {
      var d = {
        "label": 9,
      };
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/field/queryListHead";
      dio.options.contentType = Headers.formUrlEncodedContentType;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dio.options.headers["Admin-token"] = preferences.get("token");
      var response;
      response = await dio.post(baseUrl, data: d);
//print(response.data);
      if (response.data["code"] == 500) {
        BotToast.showText(text: response.data["msg"], align: Alignment.center);
        // return response.data;
      } else if (response.data["code"] == 302) {
        BotToast.showText(text: "登录过期请重新登录", align: Alignment.center);
        //return {"code": 500, "msg": "登录过期请重新登录"};
      } else {
        //return response.data;
        Map listHead = response.data;
        List a = listHead["data"];
        gongHaiDropItem = [];

        for (int i = 0; i < a.length; i++) {
          var s = a[i];

          gongHaiDropItem.add(new DropdownMenuItem(
            //margin: EdgeInsets.only(left: 100),
              child: Text(s["name"]),
              value: s));
        }
      }

//    List shangjiList=shangjiMap["data"]["list"];
//    print(shangjiList.length);
//    print(shangjiList[0]);

    } catch (e) {
      BotToast.showText(text: "网络异常", align: Alignment.center);
      // return {"code": 500, "msg": "网络异常"};
      //BotToast.showText(text: "666", align: Alignment.center);
    }
    //BotToast.showText(text:"请重新登录",align:Alignment.center);
  }
  //获取场景列表
  querySceneList() async {
    try {
      var d = {"type": 5};
      Dio dio = new Dio();
      dio.options.connectTimeout = 5000;
      var baseUrl = api + "/scene/queryScene";
      dio.options.contentType = Headers.formUrlEncodedContentType;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dio.options.headers["Admin-token"] = preferences.get("token");
      var response;
      response = await dio.post(baseUrl, data: d);

      if (response.data["code"] == 500) {
        BotToast.showText(text: response.data["msg"], align: Alignment.center);
        //return response.data;
      } else if (response.data["code"] == 302) {
        BotToast.showText(text: "登录过期请重新登录", align: Alignment.center);
        // return {"code": 500, "msg": "登录过期请重新登录"};
      } else {
        secne = response.data;
        List a = secne["data"];
        dropItem = [];
        for (int i = 0; i < a.length; i++) {
          // print(a[i]["name"]);
          dropItem.add(new DropdownMenuItem(
            //margin: EdgeInsets.only(left: 100),
            child: Text(a[i]["name"]),
            value: a[i]["name"],
          ));
        }
      }
      //return response.data;
    } catch (e) {
      BotToast.showText(text: "网络异常", align: Alignment.center);
      // return {"code": 500, "msg": "网络异常"};
      // BotToast.showText(text: "666", align: Alignment.center);
    }
    //BotToast.showText(text:"请重新登录",align:Alignment.center);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    Size screenSize = MediaQuery.of(context).size;

    final Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('首页',
          //style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[

        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      //drawer: ListDrawer(),
      body: ListView(
        children: <Widget>[
//          Container(
//            color: Colors.white,
//            //height: 100,
//            padding: EdgeInsets.only(bottom: 10, top: 10),
//            child: Center(
//              child: Text(
//                '首页',
//                style: TextStyle(
//                  fontSize: 22,
//                  //fontWeight: FontWeight.bold,
//                  //fontStyle: FontStyle.italic,
//                ),
////                          style: TextStyle(color: Colors.black,
////                              fontSize:26
////                              ,fontWeight: FontWeight.bold),
//              ),
//            ),
//          ),
          SizedBox(
            height: 10,
          ),


          // 快捷
          Container(
            padding: EdgeInsets.only(top: 10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
//                      borderRadius:BorderRadius.only(
//                        topRight: Radius.elliptical(35,35),
//                        //  bottomRight: Radius.elliptical(35,35),
//                        bottomLeft: Radius.elliptical(35,35),
//                        // topLeft: Radius.elliptical(35,35)
//                      ),
//                        boxShadow: [
//                          BoxShadow(
//                              color: Colors.grey,
//                              offset: Offset(1.0, 3.0),
//                              blurRadius: 3.0, spreadRadius: 0.7
//                          ),
////            BoxShadow(color: Color(0x9900FF00),
////                offset: Offset(1.0, 1.0)
////            ),
////            BoxShadow(color: Color(0xFF0000FF)
////            )
//                        ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  //width: double.infinity,
                  //color: Colors.cyan,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Wrap(
                    //spacing: 10.0,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/cluePage");

                          //BotToast.showText(text: "暂无",align: Alignment.center);
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
//                                        decoration: BoxDecoration(
//                                          //color: Colors.blue,
//                                          //color: Colors.grey,
//                                          borderRadius: BorderRadius.all(Radius.circular(25)),
//                                        ),
                                child: Image(
                                  image: AssetImage("assets/lead.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '线索',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
//                              InkWell(
//                                onTap: (){
//                                  Application.router.navigateTo(context, "/customerPage");
//                                  //BotToast.showText(text: "暂无",align: Alignment.center);
//                                },
//                                child: Container(
//                                  width: (screenSize.width-20)/5,
//                                  //color: Colors.grey,
//                                  child: Column(
//                                    children: <Widget>[
//                                      Container(
//                                        margin: EdgeInsets.only(bottom: 5),
//                                        width: 50,
//                                        height: 50,
//                                        //alignment: Alignment.center,
//                                        decoration: BoxDecoration(
//                                          color: Colors.deepPurpleAccent,
//                                          //color: Colors.grey,
//                                          borderRadius: BorderRadius.all(Radius.circular(25)),
//                                        ),
//                                        child: Center(
//                                          child: Icon(
//                                            Icons.supervisor_account,
//                                            size: iconSize,
//                                            color: Colors.white,
//                                          ),
//                                        ),
//                                      ),
//                                      Text('客户',style: TextStyle(fontSize: 13),)
//                                    ],
//                                  ),
//                                ),
//                              ),
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/gonghai");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.blueAccent,
                                  //color: Colors.grey,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Image(
                                  image: AssetImage("assets/publicSea.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '公海',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      //chanping
                      InkWell(
                        onTap: () {
//                          BotToast.showText(
//                              text: "暂无", align: Alignment.center);
                          Application.router.navigateTo(context, "/productPage");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  width: 50,
                                  height: 50,
                                  //alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    //color: Colors.grey,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.devices_other,
                                      size: iconSize,
                                      color: Colors.white,
                                    ),
                                  )),
                              Text(
                                '产品',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/contactPage");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.deepOrangeAccent,
                                  //color: Colors.grey,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Image(
                                  image: AssetImage("assets/contact.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '联系人',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/riskPage");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Image(
//                                  color: Colors.grey,
                                  image: AssetImage("assets/risk.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '风险',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //BotToast.showText(text: "暂无", align: Alignment.center);
                          Application.router.navigateTo(context, "/LogTapbarPage");

                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Icon(
                                  Icons.assignment,
                                  size: iconSize,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '日志',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //BotToast.showText(text: "暂无",align: Alignment.center);
                          Application.router.navigateTo(context, "/NoticeListPage");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  //color: Colors.grey,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.notifications_none,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                '公告',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/TaskTapbarPage");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.orange,

                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Image(
                                  //color: Colors.grey,
                                  image: AssetImage("assets/task.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '任务',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),

//                                  InkWell(
//                                    onTap: (){
//
//                                    },
//                                    child: Container(
//                                      width: (screenSize.width-20)/5,
//                                      child: Column(
//                                        children: <Widget>[
//                                          Container(
//                                            margin: EdgeInsets.only(bottom: 5),
//                                            width: 50,
//                                            height: 50,
//                                            //alignment: Alignment.center,
//                                            decoration: BoxDecoration(
//                                              //color: Colors.green,
//                                              color: Colors.grey,
//                                              borderRadius: BorderRadius.all(Radius.circular(25)),
//                                            ),
//                                            child: Center(
//                                              child: Icon(
//                                                Icons.monetization_on,
//                                                size: iconSize,
//                                                color: Colors.white,
//                                              ),
//                                            ),
//                                          ),
//                                          Text('商机',style: TextStyle(fontSize: 13),)
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                      InkWell(
//                        onTap: () {
//                          BotToast.showText(
//                              text: "暂无", align: Alignment.center);
//                        },
//                        child: Container(
//                          width: (screenSize.width - 20) / 5,
//                          child: Column(
//                            children: <Widget>[
//                              Container(
//                                margin: EdgeInsets.only(bottom: 5),
//                                width: 50,
//                                height: 50,
//                                //alignment: Alignment.center,
//                                decoration: BoxDecoration(
//                                  //color: Colors.cyan,
//                                  //color: Colors.grey,
//                                  borderRadius:
//                                  BorderRadius.all(Radius.circular(25)),
//                                ),
//                                child: Image(
//                                  color: Colors.grey,
//                                  image: AssetImage("assets/contract.png"),
//                                  fit: BoxFit.cover,
//                                ),
//                              ),
//                              Text(
//                                '合同',
//                                style: TextStyle(fontSize: 13),
//                              )
//                            ],
//                          ),
//                        ),
//                      ),

                      InkWell(
                        onTap: () {
                          //BotToast.showText(text: "暂无", align: Alignment.center);
                          Application.router.navigateTo(context, "/SchedulePage");
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.orange,

                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Image(
                                  //color: Colors.grey,
                                  image: AssetImage("assets/schedule.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '日程',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
//                          Navigator.push(context, CupertinoPageRoute(builder: (context){
//                            return  CameraExampleHome();
//                          }));
                          BotToast.showText(
                              text: "暂无", align: Alignment.center);
                        },
                        child: Container(
                          width: (screenSize.width - 20) / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey,

                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )
                              ),
                              Text(
                                '更多',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),


          BlocProvider<WaitBloc>(
            create: (context) {
              //print("000");
              return WaitBloc(
                  waitRepository: waitRepository)
                ..add(WaitInitEvent());
            },
            child: WaitPage(),
          ),
          BlocProvider<FunnelBloc>(
            create: (context) {
              return FunnelBloc(funnelRepository: funnelRepository)..add(FunnelInitEvent(id: -1));
            },
            child: FunnelPage(),
          ),
          //首页-销售简报
          BlocProvider<SaleBloc>(
            create: (context) {
              //print("000");
              return SaleBloc(
                  saleRepository: saleRepository)
                ..add(SaleInitEvent());
            },
            child: SaleList(),
          ),

          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 10),
            color: Colors.white,
            child: Center(
              child: InkWell(
                child: Text("更多"),
              ),
            ),
          )
        ],
      ),
    );
  }
}



//Future<Map> workPageRequest() async {
//
//  Map s=await getOaRecordPageList();
//  if(s["code"]==0 ){
//    return s["data"];
//  }
//  else {
//    BotToast.showText(text: s["msg"].toString(), align: Alignment.center);
//    return null;
//  }
//}








class TapbarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState2();
}

class _HomePageState2 extends State<TapbarPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 4,
        child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(left: 20, right: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Image(
                        image: AssetImage(
                          "assets/workbench.png",
                        ),
                        width: 18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 33),
                      child: Text(
                        "工作台",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                  indicatorColor: Color(0xFF39619E),
                  labelStyle: TextStyle(
                      color: Colors.black,
                      //fontFamily: 'ProductSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  isScrollable: true,
                  tabs: [
                    new Tab(
                      //text: "日志",
                      child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 8,
                          child: Center(
                              child: Text(
                                "日志",
                                style: TextStyle(color: Colors.black),
                              ))),
                    ),
                    new Tab(
                      child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 8,
                          child: Center(
                              child: Text("任务",
                                  style: TextStyle(color: Colors.black)))),
                    ),
                    new Tab(
                      child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 8,
                          child: Center(
                              child: Text("日程",
                                  style: TextStyle(color: Colors.black)))),
                    ),
                    new Tab(
                      child: Container(
                          width: (MediaQuery.of(context).size.width - 40) / 8,
                          child: Center(
                              child: Text("公告",
                                  style: TextStyle(color: Colors.black)))),
                    ),
                  ]),
              Divider(),
              Container(
                //color: Colors.white,

                height: 300,
                padding: EdgeInsets.only(bottom: 5,right: 50),

                child: TabBarView(children: [
                  //日志
                  BlocProvider<OaRecord1Bloc>(
                    create: (context) {
                      //print("000");
                      return OaRecord1Bloc(
                          oaRecord1Repository: oaRecord1Repository)
                        ..add(OaRecord1ListEvent(pageIndex: 1));
                    },
                    child: OaRecord1List(),
                  ),
                  //任务
                  BlocProvider<OaRecord4Bloc>(
                    create: (context) {
                      return OaRecord4Bloc(
                          oaRecord4Repository: oaRecord4Repository)
                        ..add(OaRecord4ListEvent(pageIndex: 1));
                    },
                    child: OaRecord4List(),
                  ),
                  //日程
                  BlocProvider<OaRecord2Bloc>(
                    create: (context) {
                      //print("000");
                      return OaRecord2Bloc(
                          oaRecord2Repository: oaRecord2Repository)
                        ..add(OaRecord2ListEvent(pageIndex: 1));
                    },
                    child: OaRecord2List(),
                  ),
                  //公告
                  BlocProvider<OaRecord3Bloc>(
                    create: (context) {
                      //print("000");
                      return OaRecord3Bloc(
                          oaRecord3Repository: oaRecord3Repository)
                        ..add(OaRecord3ListEvent(pageIndex: 1));
                    },
                    child: OaRecord3List(),
                  ),

                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class MessageDialog extends Dialog {
  String title;
  String message;
  String negativeText;
  String positiveText;
  Function onCloseEvent;
  Function onPositivePressEvent;

  MessageDialog({
    Key key,
    @required this.title,
    @required this.message,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    @required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(30.0),
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        new Center(
                          child: new Text(
                            title,
                            style: new TextStyle(
                              fontSize: 19.0,
                            ),
                          ),
                        ),
                        new GestureDetector(
                          onTap: this.onCloseEvent,
                          child: new Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: new Icon(
                              Icons.close,
//                              color: Color(0xffe0e0e0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffe0e0e0),
                    height: 1.0,
                  ),
                  new Container(
                    constraints: BoxConstraints(minHeight: 180.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new IntrinsicHeight(
                        child: new Text(
                          message,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  this._buildBottomButtonGroup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    return new Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomCancelButton() {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: onCloseEvent,
        child: new Text(
          negativeText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton() {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: onPositivePressEvent,
        child: new Text(
          positiveText,
          style: TextStyle(
            color: Color(Colors.blueAccent.value),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
