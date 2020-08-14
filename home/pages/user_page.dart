import 'dart:math';
import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miscrm/home/models/user_model.dart';
import 'package:miscrm/home/pages/pages.dart';
import 'package:miscrm/receivables/bloc/receivables_bloc.dart';
import 'package:miscrm/routers/application.dart';
import 'package:miscrm/config.dart';

//import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:flutter/animation.dart';
import 'package:miscrm/solution/pages/solution_page.dart';

DecorationImage profileImage;

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  Animation<double> containerGrowAnimation;
  AnimationController _screenController;
  double iconSize = 30;

  @override
  void initState() {
    super.initState();

//    profileImage = new DecorationImage(
//      image: new ExactAssetImage('assets/qr.png'),
//      fit: BoxFit.cover,
//    );
//    _screenController = new AnimationController(
//        duration: new Duration(milliseconds: 1000), vsync: this);
//
//    containerGrowAnimation = new CurvedAnimation(
//      parent: _screenController,
//      curve: Curves.easeIn,
//    );
//    containerGrowAnimation.addListener(() {
//      this.setState(() {});
//    });
//    containerGrowAnimation.addStatusListener((AnimationStatus status) {});
//    _playAnimation();


  }

  Future<Null> _playAnimation() async {
    try {
      await _screenController.forward();
      await _screenController.reverse();
      await _screenController.forward();
    } on TickerCanceled {}
  }

  @override
  void dispose() {
//    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    User user;
    if(profile != null && profile.user != null){
      user = profile.user;
    }

    return Scaffold(
        body: ListView(
      children: <Widget>[
          Container(

            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[

                //背景图片
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset("assets/background.png",fit: BoxFit.fitWidth,),
                ),
                //设置按钮 和 用户信息展示
                Container(
//                  color: Colors.blue,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          trailing: IconButton(
                            icon: Icon(
                              CupertinoIcons.gear_solid,
                              color: Colors.black,
                            ),
                            onPressed: () {
  //                            Application.router
  //                                .navigateTo(context, "/setting");
                              Navigator.of(context).push(CirclePageRoute(builder: (context) {
                                return SettingPage();
                              }));
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Application.router.navigateTo(context, "/userDetail"); //跳转到userDetail，在handler中添加了HomeBloc给下一页
                          },
                          //用户信息显示
                          child: user != null
                              ? Container(
                            margin: EdgeInsets.only(top: 0),
                            //width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                //头像显示
                                user.imgPath != null
                                    ? Container(
                                  //margin: EdgeInsets.fromLTRB(20, 25, 15, 25),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.white
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      user.imgPath,
                                      //  height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                                    :
                                    Container(
                                  //margin: EdgeInsets.fromLTRB(20, 25, 15, 25),
                                  width: 60,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
//                                    color: Colors.black45,
                                    color: Colors.blue[700],
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)),
                                  ),
                                  child: user.realname.length < 4
                                      ? (user.realname.length < 3
                                      ? Text(
                                    user.realname.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  )
                                      :Text(
                                    user.realname.toString().substring(1), //从字符串下标索引为1的字母开始一直到最后
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  )
                                  )
                                      : Text(
                                    user.realname.toString().substring(0,2),//名字大于4位，从字符串取前两个字，取到下标为2的字符前结束
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${user.username}',
                                      style: TextStyle(
                                          fontSize:
                                          15,
                                         ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${user.deptName}',
                                      style: TextStyle(
                                        fontSize:
                                        15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                              :Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              border: Border.all(
                                  width: 1,
                                  color: Colors.white),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30)),
                            ),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),

          //客户管理
          Container(
            margin: EdgeInsets.only(top: 10),
          //padding: EdgeInsets.only(right: 5),
          //color: Colors.white,
            decoration: BoxDecoration(
              color: Colors.white,

            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    '客户管理',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  //width: double.infinity,
                  //color: Colors.cyan,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 25),
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
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Image(
                                  //color: Colors.grey,
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
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/customerPage");
                          //BotToast.showText(text: "暂无",align: Alignment.center);
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          //color: Colors.grey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Center(
                                    child: Image(
                                      image: AssetImage("assets/customer.png",),
                                      color: Colors.white,
                                      width: 23,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                              Text(
                                '客户',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          Application.router
                              .navigateTo(context, "/gonghai");
  //                                Navigator.push(context, MaterialPageRoute(builder: (context){
  //                                  return GonghaiPage();
  //                                }));

                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.blueAccent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Image(
                                  //color: Colors.grey,
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

                      InkWell(
                        onTap: () {
  //                                BotToast.showText(text: "暂无",align: Alignment.center);
                          Application.router.navigateTo(context, "/contactPage");
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Image(
  //                                        color: Colors.grey,
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
                          width: (screenSize.width - 35) / 4,
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
                          Application.router.navigateTo(context, "/contractPage");
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.cyan,
                                  //color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Image(
                                  image: AssetImage("assets/contract.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '合同',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/receivablesPage");
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.orange,
                                  //color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Image(

                                  image: AssetImage("assets/returnMoney.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '回款',
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
        //产品和解决方案
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,

          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Text(
                  '产品和解决方案',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                //color: Colors.cyan,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 25),
                child: Wrap(
                  //spacing: 10.0,
                  runSpacing: 20,
                  alignment: WrapAlignment.start,
                  children: <Widget>[

                    InkWell(
                      onTap: () {
                        //                                BotToast.showText(text: "暂无",align: Alignment.center);
                        Application.router.navigateTo(context, "/productPage");
                      },
                      child: Container(
                        width: (screenSize.width - 35) / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,

                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
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
                        //                                BotToast.showText(text: "暂无",align: Alignment.center);
                        Application.router.navigateTo(context, "/servicePage");
                      },
                      child: Container(
                        width: (screenSize.width - 35) / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,

                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.bubble_chart,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                )),
                            Text(
                              '服务',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        //                                BotToast.showText(text: "暂无",align: Alignment.center);
                        Application.router.navigateTo(context, "/solutionPage");

                      },
                      child: Container(
                        width: (screenSize.width - 35) / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent,

                                  borderRadius: BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.memory,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                )),
                            Text(
                              '解决方案',
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
//                        BotToast.showText(
//                            text: "暂无", align: Alignment.center);
                      },
                      child: Container(
                        width: (screenSize.width - 35) / 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,

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
                              style: TextStyle(fontSize: 13,color: Colors.white),
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

        //我的-办公
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,

            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(
                    '办公',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  //color: Colors.cyan,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 25),
                  child: Wrap(
                    //spacing: 10.0,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/LogTapbarPage");
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.indigoAccent,
                                  color: Colors.cyan,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.assignment,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
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
  //                    InkWell(
  //                      onTap: () {},
  //                      child: Container(
  //                        width: (screenSize.width - 20) / 4,
  //                        //color: Colors.grey,
  //                        child: Column(
  //                          children: <Widget>[
  //                            Container(
  //                              margin: EdgeInsets.only(bottom: 5),
  //                              width: 50,
  //                              height: 50,
  //                              //alignment: Alignment.center,
  //                              decoration: BoxDecoration(
  //                                color: Colors.amber,
  //                                borderRadius:
  //                                    BorderRadius.all(Radius.circular(15)),
  //                              ),
  //                              child: Center(
  //                                child: Icon(
  //                                  Icons.beenhere,
  //                                  size: iconSize,
  //                                  color: Colors.white,
  //                                ),
  //                              ),
  //                            ),
  //                            Text(
  //                              '审批',
  //                              style: TextStyle(fontSize: 13),
  //                            )
  //                          ],
  //                        ),
  //                      ),
  //                    ),
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/NoticeListPage");
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  //color: Colors.deepOrange,
                                  color: Colors.blue,
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
  //                        BotToast.showText(text: "暂无",align: Alignment.center);
                          Application.router.navigateTo(context, "/addressBookPage");
                        },
                        child: Container(
                          width: (screenSize.width - 35) / 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: 50,
                                height: 50,
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
  //                              color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.contact_phone,
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                '通讯录',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),
  //                    InkWell(
  //                      onTap: () {},
  //                      child: Container(
  //                        width: (screenSize.width - 20) / 4,
  //                        child: Column(
  //                          children: <Widget>[
  //                            Container(
  //                              margin: EdgeInsets.only(bottom: 5),
  //                              width: 50,
  //                              height: 50,
  //                              //alignment: Alignment.center,
  //                              decoration: BoxDecoration(
  //                                color: Colors.cyan,
  //                                borderRadius:
  //                                    BorderRadius.all(Radius.circular(15)),
  //                              ),
  //                              child: IconButton(
  //                                icon: Icon(
  //                                  Icons.place,
  //                                  size: iconSize,
  //                                  color: Colors.white,
  //                                ),
  //                              ),
  //                            ),
  //                            Text(
  //                              '外勤签到',
  //                              style: TextStyle(fontSize: 13),
  //                            )
  //                          ],
  //                        ),
  //                      ),
  //                    ),
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
//                                  color: Colors.grey,
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
                      InkWell(
                        onTap: () {
                          Application.router.navigateTo(context, "/SchedulePage");
//                          Application.router.navigateTo(context, "/SchedulePage");
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
                    ],
                  ),
                ),
              ],
            ),
        ),
          SizedBox(
            height: 30,
          ),
      ],
    ));
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  //size：是子元素的size
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0); //第一个点，路径的开始
    path.lineTo(0, size.height - 200); //第二个点是曲线开始的位置，要比曲线的控制点低一点
    var firstControlPoint = Offset(0, size.height-100); //第一个控制点的x坐标在最左下角-120
    var firstEndPoint = Offset((size.width)/3, size.height-100); //第一个曲线结束点
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy); //绘制贝塞尔曲线，通过控制点和结束点的坐标来实现
    path.lineTo((size.width)-60, size.height-100);//第二个曲线的开始位置
    var secondControlPoint = Offset(size.width,size.height-100);//第二个控制点
    var secondEndPoint = Offset(size.width,size.height-40);//第二个曲线结束位置
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    return path; //返回路径数据
  }

  //没用，但必须重写这个方法，否则报错
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}

//class ImageBackground extends StatelessWidget {
//
//  final DecorationImage profileImage;
//
//  final Animation<double> containerGrowAnimation;
//  ImageBackground(
//      {
//        this.containerGrowAnimation,
//        this.profileImage,
//       });
//  @override
//  Widget build(BuildContext context) {
//    Size screenSize = MediaQuery.of(context).size;
//    final Orientation orientation = MediaQuery.of(context).orientation;
//    bool isLandscape = orientation == Orientation.landscape;
//    return (
//        new Container(
//          decoration: new BoxDecoration(
//              gradient: new LinearGradient(
//                colors: <Color>[
//                  const Color.fromRGBO(110, 101, 103, 0.6),
//                  const Color.fromRGBO(51, 51, 63, 0.9),
//                ],
//                stops: [0.2, 1.0],
//                begin: const FractionalOffset(0.0, 0.0),
//                end: const FractionalOffset(0.0, 1.0),
//              )),
//          child: isLandscape
//              ? new ListView(
//            children: <Widget>[
//              new Flex(
//                direction: Axis.vertical,
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  new Text(
//                    "Good Morning!",
//                    style: new TextStyle(
//                        fontSize: 30.0,
//                        letterSpacing: 1.2,
//                        fontWeight: FontWeight.w300,
//                        color: Colors.white),
//                  ),
//                  new ProfileNotification(
//                    containerGrowAnimation: containerGrowAnimation,
//                    profileImage: profileImage,
//                  ),
//
//                ],
//              )
//            ],
//          )
//              : new Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              new Text(
//                "Good Morning!",
//                style: new TextStyle(
//                    fontSize: 30.0,
//                    letterSpacing: 1.2,
//                    fontWeight: FontWeight.w300,
//                    color: Colors.white),
//              ),
//              new ProfileNotification(
//                containerGrowAnimation: containerGrowAnimation,
//                profileImage: profileImage,
//              ),
//
//            ],
//          ),
//        )
//    );
//  }
//}
//
//
//
//
//
//class ProfileNotification extends StatelessWidget {
//  final Animation<double> containerGrowAnimation;
//  final DecorationImage profileImage;
//  ProfileNotification({this.containerGrowAnimation, this.profileImage});
//  @override
//  Widget build(BuildContext context) {
//    return (
//        new Container(
//            width: containerGrowAnimation.value * 120,
//            height: containerGrowAnimation.value * 120,
//            decoration: new BoxDecoration(
//              shape: BoxShape.circle,
//              image: profileImage,
//            )
//
//        )
//
//    );
//  }
//}
class CirclePath extends CustomClipper<Path> {
  CirclePath(this.value);

  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    double radius =
        value * sqrt(size.height * size.height + size.width * size.width);
    path.addOval(Rect.fromLTRB(
        size.width - radius, -radius, size.width + radius, radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CirclePageRoute extends PageRoute {
  CirclePageRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: CirclePath(animation.value),
          child: child,
        );
      },
      child: builder(context),
    );
  }
}