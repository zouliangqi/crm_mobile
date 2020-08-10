import 'package:flutter/material.dart';

import 'package:miscrm/login/register_bloc.dart';
import 'package:miscrm/login/register_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:miscrm/system_common/system_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';

final registerRepository = RegisterRepository();

class RegisterPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,
        title: Text("注册",style: TextStyle(fontSize: 26),),
      ),
      body: BlocProvider(
        create: (context) {

          return RegisterBloc(
            registerRepository: registerRepository,
          );
        },
        child: RegisterForm(),

      ),

    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>
    with TickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _realnameController = TextEditingController();
  final _deptController = TextEditingController();
  final _mobileController = TextEditingController();
  final _sexController = TextEditingController();
  final _emailController  = TextEditingController();
  final _postController = TextEditingController();
  final _parentIdController= TextEditingController();
  var _isShow=true;
  int dept;
  int sex;
  int pre;

  final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  /// 检查是否是邮箱格式
  bool isEmail(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }


  bool isPhone(String input) {
    if (input == null || input.isEmpty) return false;
    if(input.length==11)
      return true;
    else
      return false;
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


  @override
  void initState(){
    // TODO: implement initState
    super.initState();

//      deptGet();
      userGet();
      sexGet();

    //itemAdd(sexName,sexItem);
    //itemAdd(preName,preItem);
//  }catch(e){
//  BotToast.showText(text: "网络异常",align: Alignment.center);
//  }
  }



//   deptGet() async {
//     deptName=[];
//     if(deptItem==null || deptItem==[]){
//       BotToast.showText(text: "检查网络并重新打开app",align: Alignment.center);
//       return;
//     }
//    int len=deptItem.length;
//
//     print(len);
//    for(int i=0;i<len;i++){
//      var s=deptItem[i];
//      deptName.add(
//          new DropdownMenuItem(//margin: EdgeInsets.only(left: 100),
//            child:Text(s["NAME"].toString()),
//            value: s,
//          )
//      );
//    }
//  }

  userGet() async {
    if(preItem==null || preItem==[]){
      BotToast.showText(text: "检查网络并重新打开app",align: Alignment.center);
      return;
    }
    preName=[];
    int len=preItem.length;

    for(int i=0;i<len;i++){
      var s=preItem[i];
      preName.add(
          new DropdownMenuItem(
            child: Text(
                s["realname"],
            ),

            value: s,
          )
      );
    }
  }

 sexGet() async {
   sexName=[];
    int len=sexItem.length;
    for(int i=0;i<len;i++){
      var s=sexItem[i];
      sexName.add(
          new DropdownMenuItem(
            child: Text(s["SEX"]),
            value: s,
          )
      );
    }
  }

  Map a;
  getName() async{
    a= await registerRepository.registerGetName(_usernameController.text);
    if(a["code"]==0) {
      setState(() {
        _realnameController.text = a["msg"];
      });
    }else{
      setState(() {
        _realnameController.text = "";
      });

      BotToast.showText(text: a["msg"],align:Alignment.center);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {




    _onRegisterButtonPressed() {

      if(isOkPassword(_passwordController.text)==false){
        BotToast.showText(text: "密码需要有数字、字母、大小写、特殊字符、最少8位",align:Alignment.center);
        return ;
      }



      if(_usernameController.text=="" ||
          _realnameController.text=="" ||
          _passwordController.text=="" ||
          _mobileController.text=="" ||
          _emailController.text==""  ||
          _deptController.text=="" ){
        BotToast.showText(text: "输入为空",align:Alignment.center);
        return;
      }
      if(_passwordController.text.length < 8){
        BotToast.showText(text: "密码最少8位",align:Alignment.center);
        return;
      }
      if(isEmail(_emailController.text) ==false){
        BotToast.showText(text: "邮箱格式错误",align:Alignment.center);
        return;
      }
      if(isPhone(_mobileController.text) ==false){
        BotToast.showText(text: "手机号位数错误",align:Alignment.center);
        return;
      }
    BlocProvider.of<RegisterBloc>(context).add(
        RegisterButtonPressed(
            username:_usernameController.text,
            realname:_realnameController.text,
            password:_passwordController.text,
            deptId:dept,
            mobile:_mobileController.text,
            sex:sex,
            email:_emailController.text,
            post:_postController.text,
            parentId:pre
        ),
      );
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
         // Navigator.pop(context);
          BotToast.showText(text: "${state.error}",align:Alignment.center);
        }
        else if(state is RegisterSuccess){
          Navigator.pop(context);
          BotToast.showText(text: "${state.success}",align:Alignment.center);
        }
      },
      child:
          BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if(_usernameController.text!="" || _usernameController.text !=null){
              getName();
            }

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
                          children: [

                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.person),
                                    labelText: '工号',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _usernameController,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                readOnly: true,
                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.perm_identity),
                                    labelText: '姓名',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _realnameController,
                                onTap: (){
                                  if(_usernameController.text!="" || _usernameController.text !=null ){
                                    getName();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
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
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),

                                controller: _passwordController,
                                onTap: (){
                                  if((_usernameController.text!="" || _usernameController.text !=null )
                                      && (_realnameController.text==null || _realnameController.text=="")){
                                    getName();
                                  }
                                },
                                obscureText: _isShow,
                              ),
                            ),
                            SizedBox(height: 10,),

                            Container(

                           //       color: Colors.deepOrangeAccent,
                                  padding: EdgeInsets.only(left: 30,right: 30),
                                  child: TextFormField(
                                    onTap: ()async{
                                      Map userSelected = await getDepartments(context);
                                      if(userSelected != null) {
                                        setState(() {
                                          _deptController.text =
                                          userSelected["name"];
                                          dept=userSelected["id"];
                                        });
                                      }
                                     //   sendUserIds2 = userSelected["id"].toString();
                                    },
                                   // maxLength: 10,
                                    maxLengthEnforced: false,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    textInputAction:TextInputAction.done,
                                   readOnly: true,
                                     // enabled:false,
                                    decoration: InputDecoration(

                                        prefixIcon: Icon(Icons.location_city),
                                        labelText: '部门',
                                        contentPadding: EdgeInsets.all(10.0),
//                                    suffix:

//                                    InkWell(
//                                      child: Icon(Icons.keyboard_arrow_down),
//                                      onTap: (){
//                                        showDialog(
//                                            context: context,
//                                            builder: (context) {
//                                              return AlertDialog(
//
//                                                content:  SingleChildScrollView(
//                                                  child: Column(
//                                                    children: <Widget>[
//                                                      ListTile(
//                                                        leading: Radio<String>(
//                                                            value: "否",
//                                                            groupValue: dept,
//                                                            activeColor: Colors.lightBlue,
//                                                            onChanged: (value) {
//                                                              setState(() {
//                                                                dept = value;
//                                                              });
//                                                            }),
//                                                        title: Text("MIS",style: TextStyle(fontSize: 15),),
//                                                      ),
//                                                      ListTile(
//                                                        leading: Radio<String>(
//                                                            value: "是",
//                                                            groupValue: dept,
//                                                            activeColor: Colors.lightBlue,
//                                                            onChanged: (value) {
//                                                              setState(() {
//                                                                dept = value;
//                                                              });
//                                                            }),
//                                                        title: Text("MIS",style: TextStyle(fontSize: 15),),
//                                                      ),
//                                                    ],
//                                                  ),
//                                                ),
//                                                actions: <Widget>[
//
//
//
//                                                ],
//                                              );
//                                            });
////                                        setState(() {
////                                          _deptController.text="666";
////                                        });
//
//                                      },
//                                    ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        )


                                    ),
                                    style: TextStyle(fontSize: 18),
                                    controller: _deptController,
                                  ),
                                ),


                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.phone,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.phone_android),
                                    labelText: '手机号',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _mobileController,
                                onTap: (){
                                  if((_usernameController.text!="" || _usernameController.text !=null )
                                      && (_realnameController.text==null || _realnameController.text=="")){
                                    getName();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                readOnly: true,
                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.person_pin),
                                    labelText: '性别',
                                    contentPadding: EdgeInsets.all(10.0),
                                    suffix: DropdownButtonHideUnderline(
                                      child:  new DropdownButton(


                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.lightBlue,
                                        ),
                                       // hint: new Text('请选择'),
                                        onChanged: (value) {
                                          setState(() {
                                                  sex = value["ID"];
                                                  print(sex);
                                            _sexController.text=value["SEX"];
                                            FocusScope.of(context).requestFocus(new FocusNode());

                                          });
                                          if((_usernameController.text!="" || _usernameController.text !=null )
                                              && (_realnameController.text==null || _realnameController.text=="")){
                                            getName();
                                          }
                                        },
//                                              value: dept,
                                        //elevation: 54, //设置阴影的高度
                                        style: new TextStyle(
                                          //设置文本框里面文字的样式
                                          color: Color(0xff4a4a4a),
                                          fontSize: 15,
                                        ),
                                        isDense: true, //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                                        items: sexName,

                                        //iconSize: 40.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _sexController,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.emailAddress,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.person),
                                    labelText: '邮箱',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _emailController,
                                onTap: (){
                                  if((_usernameController.text!="" || _usernameController.text !=null )
                                      && (_realnameController.text==null || _realnameController.text=="")){
                                    getName();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.personal_video),
                                    labelText: '岗位',
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _postController,
                                onTap: (){
                                  if((_usernameController.text!="" || _usernameController.text !=null )
                                      && (_realnameController.text==null || _realnameController.text=="")){
                                    getName();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                readOnly: true,
                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.portrait),
                                    labelText: '直属上级',
                                    contentPadding: EdgeInsets.all(10.0),
                                    suffix:DropdownButtonHideUnderline(
                                      child:  new DropdownButton(


                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.lightBlue,
                                        ),
                                       // hint: new Text('请选择'),
                                        onChanged: (value) {
                                          setState(() {
                                             pre = value["userId"];
                                             print(pre);
                                            _parentIdController.text=value["realname"];
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                          });
                                          if((_usernameController.text!="" || _usernameController.text !=null )
                                              && (_realnameController.text==null || _realnameController.text=="")){
                                            getName();
                                          }
                                        },
//                                              value: dept,
                                        //elevation: 54, //设置阴影的高度
                                        style: new TextStyle(
                                          //设置文本框里面文字的样式
                                          color: Color(0xff4a4a4a),
                                          fontSize: 15,
                                        ),
                                        isDense: true, //减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
                                        items: preName,

                                        //iconSize: 40.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _parentIdController,
                              ),
                            ),

                            SizedBox(height: 140,),


//                            RaisedButton(
//                              onPressed: (){
//
//                                _onLoginButtonPressed();
//                              },
//                            ),



                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: new InkWell(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                });
                                _onRegisterButtonPressed();
                              },
                              child: new Container(
                                width: 320.0,
                                height: 55.0,
                                alignment: FractionalOffset.center,
                                decoration: new BoxDecoration(
                                  color: Color(0xFF39619E),
                                  //gradient: const LinearGradient(colors: [Color(0xFF0FE3FF),Color(0xFF00A8E7),Color(0xFF1472FF),Color(0xFF1472FF)]),
                                  borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(1.0, 3.0),
                                        blurRadius: 5.0, spreadRadius: 0.7
                                    ),
//            BoxShadow(color: Color(0x9900FF00),
//                offset: Offset(1.0, 1.0)
//            ),
//            BoxShadow(color: Color(0xFF0000FF)
//            )
                                  ],
                                ),
                                child:!(state is RegisterLoading)
                                    ? Text("注册",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                  ),
                                )
                              :CircularProgressIndicator(
                                  value: null,
                                  strokeWidth: 1.0,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              ),

                          ),
                        )

                      ],
                    ),


                  ],
                )
            ),
          ),


        );

      }),
    );
  }
}
