
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miscrm/login/user_repository.dart';
import 'package:miscrm/login/authen_bloc.dart';
import 'package:miscrm/login/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/animation.dart';
import '../../config.dart';
import 'donghua.dart';

import 'package:flutter/foundation.dart';

import 'dart:async';

import 'register.dart';

import 'package:flutter/services.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:miscrm/routers/application.dart';
import 'data.dart';

import 'dart:io';


import 'package:dio/dio.dart';

import 'dart:convert';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isShow=true;

  String _message = '';

  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLoginMsg();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      EasyLoading.showSuccess('Great Success!');
//    });



  }




  void _getLoginMsg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _usernameController.text = preferences.get("name");
    //_passwordController.text = preferences.get("pwd");
//    deptItem=await registerRepository.registerGetDept();
//    print(deptItem);
    preItem=await registerRepository.registerGetUser();

  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }
  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);


     bool isLoginPassword(String input) {
      RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$");
      return mobile.hasMatch(input);
    }

    bool isOkPassword(String password) {
      if (password?.isNotEmpty != true) return false;//密码为空，弱密码
      if (password.length < 8) return false;//位数不足，弱密码
      int a=0;
      int b=0;
      int c=0;
      int d=0;
      for (var code in password.codeUnits) {
        if (code >= 48 && code <= 57)
          a=1;
        else if (code >= 65 && code <= 90)
          b=1;
        else if (code >= 97 && code <= 122)
          c=1;
        else
          d=1;
      }

      return a+b+c+d == 4;
    }

    _onLoginButtonPressed() {


//      String p=_passwordController.text;
//     if(isOkPassword(p) == false) {
//       BotToast.showText(text: "密码需要有数字、字母、大小写、特殊字符、最少8位",align:Alignment.center);
//       return ;
//     }


      if(_usernameController.text=="" || _passwordController.text=="" ){
        BotToast.showText(text: "输入为空",align:Alignment.center);
        return;
      }

      userCode = _usernameController.text;
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(

      listener: (context, state) {
        if (state is LoginFailure) {
          BotToast.showText(text:"${state.error}",align:Alignment.center);
//          Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text('${state.error}'),
//              backgroundColor: Colors.red,
//            ),
//          );
        }

      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child:  Container(
              color: Colors.white,
              child: Form(
                  child: ListView(
                    children: <Widget>[
                      Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Container(
                                    padding: EdgeInsets.only(top: 100,bottom: 100,),
                                      child: Image.asset("assets/CRM.jpg",scale: 2.3,)
                                  ),
                                ),
                            //    SizedBox(height: 20,),
                                Container(


                                  padding: EdgeInsets.only(left: 30,right: 30),
                                  child: Theme(
                                    data: ThemeData(
                                      //scaffoldBackgroundColor: Color(0x0539619E),
                                      primaryColor: Color(0xFF39619E),//Color(0xFF39619E)
                                    ),
                                    child: TextFormField(

                                      keyboardType: TextInputType.text,
                                      textInputAction:TextInputAction.done,
                                      decoration: InputDecoration(
                                        focusColor:  Color(0xFF39619E),
                                        hoverColor:  Color(0xFF39619E),
                                        fillColor: Colors.transparent,
                                          filled: true,
                                          prefixIcon: Icon(Icons.person),
                                          labelText: '用户名',
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          )

                                      ),
                                      style: TextStyle(fontSize: 18),
                                      controller: _usernameController,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  padding: EdgeInsets.only(left: 30,right: 30),
                                  child: Theme(
                                    data: ThemeData(
                                      //scaffoldBackgroundColor: Color(0x0539619E),
                                      primaryColor: Color(0xFF39619E),//Color(0xFF39619E)
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          labelText: '密码',
                                          contentPadding: EdgeInsets.all(10.0),
                                          suffix: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  if(_isShow==true)
                                                    _isShow=false;
                                                  else
                                                    _isShow=true;

                                                });
                                              },
                                              child: Icon(
                                                Icons.remove_red_eye,
                                                color: !_isShow ? Theme.of(context).primaryColor : Colors.grey,
                                              )
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          )

                                      ),
                                      style: TextStyle(fontSize: 18),

                                      controller: _passwordController,
                                      obscureText: _isShow,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30,right: 30,top: 1.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[

                                      FlatButton(
                                          child: Text(
                                            "注册    ",
                                            style: TextStyle(
                                              color: Color(0xFF39619E),
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          onPressed: () {
                                           // final registerRepository = RegisterRepository();
                                            FocusScope.of(context).requestFocus(FocusNode());
                                            Application.router.navigateTo(context, '/register',);

//                                            Navigator.push(context, MaterialPageRoute(builder: (context){
//                                              return RegisterPage(registerRepository: registerRepository,);
//                                            }));
                                        //    BotToast.showText(text:"注册成功");
//                                      Scaffold.of(context).showSnackBar(
//                                        SnackBar(
//                                          backgroundColor: Theme.of(context).primaryColor,
//                                          content: Text('注册'),
//                                        ),
//                                      );
                                          }),

                                      FlatButton(
                                          child: Text(
                                            "忘记密码?", //
                                             style: TextStyle(
                                                 color: Color(0xFF39619E),

                                               fontWeight: FontWeight.bold
                                             ),
                                          ),
                                          onPressed: () {
                                            FocusScope.of(context).requestFocus(FocusNode());

                                            if(ip=="http://193.112.74.8") {
                                              BotToast.showText(
                                                  text: "重置密码请联系系统管理员elvis.w.zhang@mail.foxconn.com 处理",
                                                  align: Alignment.center);
                                            }
                                            else{
                                              Application.router.navigateTo(context, '/forgetPassword',);
                                            }
                                          }),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20,),
//                      Container(
//                        //margin: EdgeInsets.only(left: 180,right: 180),
//                        child: FloatingActionButton(
//
//
//                          backgroundColor: Theme.of(context).primaryColor,
//                          onPressed:
//                          state is !LoginLoading ? _onLoginButtonPressed : null,
//                          child: Icon(Icons.arrow_forward,size: 20),
//                        ),
//                      ),
//                            Container(
//                              //margin: EdgeInsets.only(left: 180,right: 180),
//                              child: FloatingActionButton(
//
//
//                                  backgroundColor: Theme.of(context).primaryColor,
//                                  onPressed:
//                                  state is !LoginLoading ? _onLoginButtonPressed : null,
//                                  child: state is LoginLoading
//                                      ?CircularProgressIndicator(
//                                    backgroundColor: Colors.white,
//                                  )
//                                      :Icon(Icons.arrow_forward,size: 20)
//                              ),
//                            ),


                                SizedBox(height: 100,),
                              ],
                            ),
                            state is !LoginLoading
                                ? new Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: new InkWell(
                                  onTap: () {
                                    setState(() {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      animationStatus = 1;
                                    });
                                    _onLoginButtonPressed();
                                    _playAnimation();
                                  },
                                  child: new SignIn()),
                            )
                                : new StaggerAnimation(

                                buttonController:
                                _loginButtonController.view),

                            Container(
                              //margin: EdgeInsets.only(top: 100),
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                child: Text("6",style: TextStyle(color: Colors.white),),
                                onTap: (){
                                  showDialog(
                                      context: context, //BuildContext对象
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return new MessageDialog ( //调用对话框
                                          title: '更改ip',
                                          message: "点击切换测试服和正式服,当前ip: $ip",
                                          positiveText: '确定',
                                          onCloseEvent: (){
                                            Navigator.pop(context);
                                          },
                                          onPositivePressEvent: (){
                                            if(ip=="http://193.112.74.8"){
                                              ip="http://45.40.235.233";
                                              api=ip+"/crmapi";
                                              imgUrl = ip+"/app/qr.png";
                                              url = ip+"/app/notification.json";
                                            }
                                            else{
                                              ip="http://193.112.74.8";
                                              api=ip+"/crmapi";
                                              imgUrl = ip+"/app/qr.png";
                                              url = ip+"/app/notification.json";
                                            }
                                            Navigator.pop(context);
                                          },
                                        );
                                      });
                                },
                              ),
                            )
                          ]
                      ),

                    ],
                  )
              ),
            ),
          );


        },
      ),
    );
  }
}



class SignIn extends StatelessWidget {
  SignIn();
  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: EdgeInsets.only(left: 30,right: 30),
      height: 55.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: Color(0xFF39619E),
        //color: Theme.of(context).primaryColor,
        //gradient: const LinearGradient(colors: [Color(0xFF0FE3FF),Color(0xFF00A8E7),Color(0xFF1472FF),Color(0xFF1473FF)]),
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0, spreadRadius: 0.7
            ),
//            BoxShadow(color: Color(0x9900FF00),
//                offset: Offset(1.0, 1.0)
//            ),
//            BoxShadow(color: Color(0xFF0000FF)
//            )
          ],

      ),
      child: new Text(
        "登录",
        style: new TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }
}

class AppInfo {
  final bool hasUpdate;
  final bool isIgnorable;
  final int versionCode;
  final String versionName;
  final String updateLog;
  final String apkUrl;
  final int apkSize;

  AppInfo({
    this.hasUpdate,
    this.isIgnorable,
    this.versionCode,
    this.versionName,
    this.updateLog,
    this.apkUrl,
    this.apkSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasUpdate': hasUpdate,
      'isIgnorable': isIgnorable,
      'versionCode': versionCode,
      'versionName': versionName,
      'updateLog': updateLog,
      'apkUrl': apkUrl,
      'apkSize': apkSize,
    };
  }

  static AppInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppInfo(
      hasUpdate: map['hasUpdate'],
      isIgnorable: map['isIgnorable'],
      versionCode: map['versionCode']?.toInt(),
      versionName: map['versionName'],
      updateLog: map['updateLog'],
      apkUrl: map['apkUrl'],
      apkSize: map['apkSize']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  static AppInfo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppInfo hasUpdate: $hasUpdate, isIgnorable: $isIgnorable, versionCode: $versionCode, versionName: $versionName, updateLog: $updateLog, apkUrl: $apkUrl, apkSize: $apkSize';
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
              margin: const EdgeInsets.all(12.0),
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
                              color: Color(0xffe0e0e0),
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
    if (negativeText != null && negativeText.isNotEmpty) widgets.add(
        _buildBottomCancelButton());
    if (positiveText != null && positiveText.isNotEmpty) widgets.add(
        _buildBottomPositiveButton());
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