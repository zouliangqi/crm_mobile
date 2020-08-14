import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:miscrm/login/authen_bloc.dart';
import 'package:miscrm/login/login_bloc.dart';
import 'package:miscrm/login/pages/change_password.dart';
import 'package:miscrm/login/user_repository.dart';

import 'package:dio/dio.dart';


import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/animation.dart';


import 'dart:async';


import 'package:miscrm/login/pages/data.dart';
import 'dart:io';


import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';


class SettingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:SettingForm(),
//      body: BlocProvider(
//        create: (context) {
//          return LoginBloc(
//            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
//            userRepository: userRepository,
//          );
//        },
//        child: SettingForm(),
//      ),
    );
  }
}

class SettingForm extends StatefulWidget {
  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm>{

  static const Cubic ease = Cubic(3.1, 0.1, 3.1, 3.0);
  String _message = '';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  ///#########################  检查更新  ################################



  void updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }






  Future<Map> downloadJson() async {
    try {
      Dio dio = new Dio();
      var response;
      response = await dio.get("http://193.112.74.8/app/upgrade.json");

      print(response.data);
      return response.data;

    }catch(e){
      return {
        "code":500,
      };
    }
  }

  ///#################################################################


  _launchPhone() async {
    const url = 'tel:18038072453';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("修改密码"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: ((context, animation, secondaryAnimation) =>
                                  BlocProvider(
                                    create: (context) {
                                      final d = UserRepository();
                                      LoginBloc(
                                        authenticationBloc:
                                            BlocProvider.of<AuthenticationBloc>(
                                                context),
                                        userRepository: d,
                                      );
                                    },
                                    child: changePwdPage(),
                                  )),
                          transitionsBuilder:(context, animation, secondaryAnimation, child) {
                            var begin = Offset(6.0, 0.1);
                            var end = Offset(0.0, 0.0);
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: Curves.ease));
                           // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
                            var offsetAnimation = animation.drive(tween);


                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );

                      }

                      ));
                    },
                  ),
                  ListTile(
                    title: Text("当前版本"),
                    trailing: Text("${versioncode}"),
                    //Icon(Icons.keyboard_arrow_right),
//                    Row(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//
//                          Icon(Icons.keyboard_arrow_right),
//                        ],
//                      ),
//                    onTap: () {
//
//                      BotToast.showLoading(
//                          backgroundColor: Colors.black26,
//                        duration: Duration(milliseconds: 200),
//                        crossPage: false,
//                        allowClick: true,
//
//                      );
//
//
//
//
//
//                    },
                  ),
                  ListTile(
                    title: Text("联系我们"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      _launchPhone();

                    },
                  ),
                  ListTile(
                    title: Text("分享APP"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {

                      BotToast.showAnimationWidget(
                          toastBuilder: (_)=>Center(
                            //color: Colors.lightBlue,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(imgUrl),
                              ),
                            ),
                          ),
                         animationDuration: Duration(milliseconds: 100),
                          crossPage: false,
                        clickClose: true,
                        backButtonBehavior: BackButtonBehavior.close,

                        backgroundColor: Colors.black26
                      );


//                      BotToast.showAttachedWidget(
//
//                          attachedBuilder  : (_) => Center(
//                            //color: Colors.lightBlue,
//                            child: Card(
//                              child: Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Image.asset("assets/qr.png",scale: 2,),
//                              ),
//                            ),
//                          ),
//                        onClose: (){
//                            print("dd");
//                        },
//                         //allowClick: false,
//                          ignoreContentClick: true,
//                         // duration: Duration(seconds: 2),
//                          target: Offset(520, 520)
//                      );

//                      showWidget(
//                        //  duration: Duration(seconds: 2),
//                        toastBuilder: ((context){
//
//                          return Scaffold(
//                            appBar: AppBar(
//                              title: Text('扫码下载'),
//                              elevation: 0,
//                              centerTitle: true,
//                              backgroundColor: Colors.white,
//                            ),
//                            body: Container(
//                              // color: Colors.lightBlue,
//                              child: Center(
//                                child:ListView(
//                                  children: <Widget>[
//                                    //SizedBox(height: 10,),
//                                    // Text("扫码下载",textAlign: TextAlign.center,),
//                                    Image.asset("assets/qr.png",scale: 2,),
//                                    Padding(
//                                      padding: EdgeInsets.only(left: 100,right: 100),
//                                      child:IconButton(
//
//                                        iconSize: 50,
//                                        icon: Icon(
//                                            CupertinoIcons.clear_circled
//                                        ),
//                                        onPressed: (){
//                                          BotToast.removeAll();
//                                        },
//                                      ),
//                                    ),
//
//                                  ],
//                                ),
//                              ),
//                            ),
//                          );
//
//
//                        }),
//                      );


                    },
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      '退出登录',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  )),
            ),
          ],
        ),
      );

  }
}
