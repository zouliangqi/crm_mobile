import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miscrm/customized_widgets/customized_widgets.dart';
import 'package:miscrm/home/blocs/bloc.dart';
import 'package:miscrm/config.dart';
import 'package:miscrm/login/pages/splash.dart';
import 'package:dio/dio.dart';

import 'dart:io';


final token = myToken;

class UserDetail extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('个人信息'),
        backgroundColor: Colors.white,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.refresh),
//            onPressed: () {
//              print('config中的token是：$token');
//              BlocProvider.of<HomeBloc>(context)
//                  .add(FetchUserDetail(token: token));
//            },
//          )
//        ],
      ),
      body:UserDetailForm(),
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

class UserDetailForm extends StatefulWidget {
  @override
  State<UserDetailForm> createState() => _UserDetailFormState();
}

class _UserDetailFormState extends State<UserDetailForm>{







  File _image;

//  Future getImage() async {
//    /var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    //var pngBytes = await image.readAsBytes();
//    //Uint8List pngBytes = await image.readAsBytes();
//
//
//   // Uint8List stuff= pngBytes.asUint8List();
//    if(image==null){}
//    else{Map a=await _upLoadImage(image);
//    if(a["code"]==0){
//      BlocProvider.of<HomeBloc>(context)
//          .add(FetchUserDetail(token: token));
//    }
//    else if(a["code"]==500){
//      BotToast.showText(text: a["msg"],align: Alignment.center);
//    }
//    else{
//      BotToast.showText(text: "登录过期，请关闭app重新登录",align: Alignment.center);
//    }
//
//    setState(() {
//      _image = image;
//    });}
//  }
  Future<Map> _upLoadImage(File image) async{
    showMyLoadingDialog(context,hintText: "正在上传",);
    String path = image.path;

    print("$path");
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    print(token);
    try{
//      var d = {
//        "userId": 6,
//        "file": pngBytes
//      };
      FormData d = new FormData.fromMap({
        "userId": profile.user.userId,
        "file": await MultipartFile.fromFile(path, filename: name)
      });

        Dio dio = new Dio(); //
        dio.options.connectTimeout = 5000;
        var baseUrl = api+"/system/user/updateImg";
        dio.options.contentType = Headers.formUrlEncodedContentType;

        dio.options.headers["Admin-token"]=token;
        var response;
        response = await dio.post(
          baseUrl,
          data: d,
        );

        print(response.data);
      Navigator.pop(context);
        return response.data;
    }catch(e){
      print(e);
      return {
        "code":500,
        "msg":"网络异常"
      };
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<String> editDetailDialog({@required String dialogTitle, String defaultContent}) {

      //TextField的控制器，同时也是保存本方法返回所需的字符串
      final _updateController = TextEditingController();

      bool _switchSelected=false;//维护单选开关状态

      if(dialogTitle != "修改性别"){
        _updateController.text = defaultContent;//如果不是"修改性别"则展示默认内容在TextField里面
      }else{
        _updateController.text = "男";//如果未触发单选开关时，点击确认返回的字符串默认值为"男"
      }

      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                dialogTitle,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              content: dialogTitle != "修改性别"
                  ? TextField(
                      controller: _updateController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                    )
                  : Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("男",),
                          Container(
                            width: 100,
                            child: DialogCheckbox(
                              value: _switchSelected,//当前状态
                              onChanged: (bool value) {
                                //更新选中状态,false为男，true为女
//                                print("value: $value");
                                _switchSelected = value;
                                print("_switchSelected: $_switchSelected");
                              if(_switchSelected==true){
                                _updateController.text = "女";
//                                print(_updateController.text);
                              }else{
                                _updateController.text = "男";
                              }
                              },
                            ),
                          ),
                          Text("女",),

                        ],
                      ),
                    ),
              actions: <Widget>[
                FlatButton(
                  child: Text('取消'),
                  onPressed: () => Navigator.of(context).pop(),
                  //onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                    child: Text('确认'),
                    onPressed: () {
//                    BlocProvider.of<HomeBloc>(context).add(
//                        UpdateUserDetail(
//                        changeInfo: {"$updateKey":"${_updateController.text}",token:token})
//                    );
                      Navigator.of(context).pop(_updateController.text);
                    }),
              ],
            );
          });
    }

    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
//          if (state is InitialHomeState){
//            return Container(
//              color: Colors.white,
//              child: Center(
//                child: Image(
//                  image: AssetImage('assets/loading_splash.gif'),
//                  //fit: BoxFit.fill,
//                  //width: 150,
//                ),
//              ),
//            );
//          }
            //成功加载了用户信息的状态

            if (state is UserDetailLoaded) {
              final user = state.user;
              profile.user=user;
              return ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 10),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, //尽可能少占用空间，默认值MainAxisSize.max，则Column会在垂直方向占用尽可能多的空间
                      children: <Widget>[
//                        Center(
//                          child: _image == null
//                              ? Text('No image selected.')
//                              : Image.file(_image),
//                        ),
                        ListTile(
                          dense: false,
                          title: Text('头像'),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                user.imgPath != null
                                    ? Container(
                                  //margin: EdgeInsets.fromLTRB(20, 25, 15, 25),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(40)),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      // "http://106.53.10.85:10203/crmapi//20200415/scaled_timg (1)10.jpg",
                                      user.imgPath,
                                      //  height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )

//                                ClipOval(
//                                        child: Image.network(
//                                          user.imgPath,
//                                          height: 100,
//                                        ),
//                                      )
                                    : ClipOval(
                                        child: Container(
                                        alignment: Alignment.center,
                                        width: 60,
                                        color: Colors.blue[700],
                                        child: Text(
                                          user.realname.toString().substring(1),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            //getImage();
                            var file=await FilePicker.getFile(type: FileType.image);

                            if(file!=null) {
                              var rec = await _upLoadImage(file);
                              if (rec["code"]==0){
                                homeBloc.add(
                                    FetchUserDetail(
                                        token: token));
                              }
                            }
                            else
                              print("no file");


                          },
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '用户名（工号）',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.username ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '姓名',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.realname ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                          ),
                          onTap: () async {
                            var changeContent = await editDetailDialog(
                                dialogTitle: "修改姓名",
                                defaultContent: user.realname);
                            if (changeContent != "" && changeContent != null) {
                              homeBloc.add(UpdateUserDetail(
                                  changeInfo: {"realname": "$changeContent"},
                                  token: token));
                            } else {
//                              BotToast.showText(
//                                  text: "输入为空", align: Alignment.center);
                            }
                          },
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '性别',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.sex ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () async {
                            var changeContent = await editDetailDialog(
                                dialogTitle: "修改性别", defaultContent: user.sex);
                            if (changeContent != "" && changeContent != null) {
                              homeBloc.add(UpdateUserDetail(
                                  changeInfo: {"sex": "$changeContent"},
                                  token: token));
                            } else {
//                              BotToast.showText(
//                                  text: "输入为空", align: Alignment.center);
                            }
                          },
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '邮箱',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.email ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () async {
                            var changeContent = await editDetailDialog(
                                dialogTitle: "修改邮箱地址",
                                defaultContent: user.email);
                            if (changeContent != "" && changeContent != null) {
                              if(isEmail(changeContent)){
                                homeBloc.add(UpdateUserDetail(
                                    changeInfo: {"email": "$changeContent"},
                                    token: token));
                              }else{
                                showMyToastText(tipText: "邮箱格式不正确", isOk: false);
                              }
                            }
                          },
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '岗位',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.position ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () async {
                            var changeContent = await editDetailDialog(
                                dialogTitle: "修改岗位",
                                defaultContent: user.position);
                            if (changeContent != "" && changeContent != null) {
                              homeBloc.add(UpdateUserDetail(
                                  changeInfo: {"post": "$changeContent"},
                                  token: token));
                            } else {
//                              BotToast.showText(
//                                  text: "输入为空", align: Alignment.center);
                            }
                          },
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '电话',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.mobile ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () async {
                            var changeContent = await editDetailDialog(
                                dialogTitle: "修改联系电话",
                                defaultContent: user.mobile);
                            if (changeContent != "" && changeContent != null) {
                              homeBloc.add(UpdateUserDetail(
                                  changeInfo: {"mobile": "$changeContent"},
                                  token: token));
                            } else {
//                              BotToast.showText(
//                                  text: "输入为空", align: Alignment.center);
                            }
                          },
                        ),
                        ListTile(
                          dense: false,
                          leading: Text(
                            '部门',
                            style: TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            user.deptName ?? "",
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            if (state is UpdateUserSuccess) {
              BotToast.showText(text: "修改成功", align: Alignment.center);
              homeBloc.add(FetchUserDetail(token: token));
              return Text("");
            }
            if (state is UpdateUserFail) {
              BotToast.showText(text: state.msg, align: Alignment.center);
              homeBloc.add(FetchUserDetail(token: token));
              return Text("");
            }

           // BotToast.showText(text: "登录过期请重新登录",align: Alignment.center);
            return Container(
              // width: 200,
              child: Center(
//                    child: Image(
//                      image: AssetImage("assets/404.png"),
//                      fit: BoxFit.fitWidth,)
                child: Image.asset(
                  "assets/404.png",
                  width: 200,
                ),
              ),
            );

            //return;
          },
        ),
      );

  }
}
final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

/// 检查是否是邮箱格式
bool isEmail(String input) {
  if (input == null || input.isEmpty) return false;
  return new RegExp(regexEmail).hasMatch(input);
}

// 单独封装一个内部管理选中状态的复选框组件
class DialogCheckbox extends StatefulWidget {
  DialogCheckbox({
    Key key,
    this.value,
    @required this.onChanged,
  });

  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  _DialogCheckboxState createState() => _DialogCheckboxState();
}

class _DialogCheckboxState extends State<DialogCheckbox> {
  bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    return Checkbox(
//      value: value,
//      onChanged: (v) {
//        //将选中状态通过事件的形式抛出
//        widget.onChanged(v);
//        setState(() {
//          //更新自身选中状态
//          value = v;
//        });
//      },
//    );
  return Switch(
    value: value,//当前状态
    onChanged:(v){
      widget.onChanged(v);
      //重新构建页面
      setState(() {
        value=v;
      });
    },
  );
  }
}
