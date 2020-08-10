import 'package:flutter/material.dart';


import 'package:miscrm/login/changePwd_bloc.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:miscrm/login/authen_bloc.dart';

class updatePwdPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 2,

        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("更新密码"),
      ),
      body: BlocProvider(
        create: (context) {

          return ChangePwdBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          );
        },
        child: ChangePwdForm(),

      ),

    );
  }
}

class ChangePwdForm extends StatefulWidget {
  @override
  State<ChangePwdForm> createState() => _ChangePwdFormState();
}

class _ChangePwdFormState extends State<ChangePwdForm>
    with TickerProviderStateMixin {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();
  final _passwordController3 = TextEditingController();

  var _isShow1=true;
  var _isShow2=true;
  var _isShow3=true;






  @override
  void initState(){
    // TODO: implement initState
    super.initState();

  }






  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

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

    _onChangePwdButtonPressed() {
      if(isOkPassword(_passwordController2.text)==false){
        BotToast.showText(text: "密码需要有数字、字母、大小写、特殊字符、最少8位",align:Alignment.center);
        return ;
      }
      if(_passwordController1.text=="" ||
          _passwordController2.text=="" ||
          _passwordController3.text==""){
        BotToast.showText(text: "输入为空",align:Alignment.center);
        return;
      }
      if(_passwordController2.text.length < 8){
        BotToast.showText(text: "密码最少8位",align:Alignment.center);
        return;
      }
      if(_passwordController2.text!=_passwordController3.text){

        BotToast.showText(text: "新密码前后输入不一样",align:Alignment.center);
        return;

      }
      BlocProvider.of<ChangePwdBloc>(context).add(

        ChangePwdButtonPressed2(
          password1:_passwordController1.text,
          password2:_passwordController2.text,
        ),
      );
    }

    return BlocListener<ChangePwdBloc, ChangePwdState>(
      listener: (context, state) {
        if (state is ChangePwdFailure) {
          BotToast.showText(text: "${state.error}",align:Alignment.center);
        }
        else if(state is ChangePwdSuccess){
          BlocProvider.of<AuthenticationBloc>(context).add(ReLogin());
          Navigator.pop(context);
          Navigator.pop(context);
          // final u=UserRepository();
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          已过期 LoginPage(userRepository: u,);
//        }));
          BotToast.showText(text: "${state.success}",align:Alignment.center);
        }
      },
      child:
      BlocBuilder<ChangePwdBloc, ChangePwdState>(builder: (context, state) {
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
                          children: [

                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.lock),
                                    labelText: '旧密码',
                                    contentPadding: EdgeInsets.all(10.0),
                                    suffix: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            if(_isShow1==true)
                                              _isShow1=false;
                                            else
                                              _isShow1=true;

                                          });
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: !_isShow1 ? Theme.of(context).primaryColor : Colors.grey,
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _passwordController1,
                                obscureText: _isShow1,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.text,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.lock_outline),
                                    labelText: '新密码',
                                    contentPadding: EdgeInsets.all(10.0),
                                    suffix: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            if(_isShow2==true)
                                              _isShow2=false;
                                            else
                                              _isShow2=true;

                                          });
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: !_isShow2 ? Theme.of(context).primaryColor : Colors.grey,
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _passwordController2,
                                obscureText: _isShow2,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    labelText: '确认密码',
                                    contentPadding: EdgeInsets.all(10.0),
                                    suffix: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            if(_isShow3==true)
                                              _isShow3=false;
                                            else
                                              _isShow3=true;

                                          });
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: !_isShow3 ? Theme.of(context).primaryColor : Colors.grey,
                                        )
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),

                                controller: _passwordController3,
                                obscureText: _isShow3,
                              ),
                            ),
                            SizedBox(height: 140,),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: new InkWell(
                            onTap: () {
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                              });
                              _onChangePwdButtonPressed();

                            },
                            child: new Container(
                                margin: EdgeInsets.only(left: 30,right: 30),
                                height: 55.0,
                                alignment: FractionalOffset.center,
                                decoration: new BoxDecoration(
                                  //color: Theme.of(context).primaryColor,
                                  color: Color(0xFF39619E),
                                  //gradient: const LinearGradient(colors: [Color(0xFF0FE3FF),Color(0xFF00A8E7),Color(0xFF1472FF),Color(0xFF1472FF)]),
                                  borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 5.0, spreadRadius: 0.7
                                    ),
                                  ],
                                ),
                                child:!(state is ChangePwdLoading)
                                    ? Text("确定",
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
                                      Colors.white
                                  ),
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
