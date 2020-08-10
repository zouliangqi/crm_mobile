import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:miscrm/login/changePwd_bloc.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';

import '../authen_bloc.dart';


class ForgetPwdPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("忘记密码"),
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



    _onChangePwdButtonPressed() {
      if(_passwordController1.text=="" ||
          _passwordController2.text==""
          ){
        BotToast.showText(text: "输入为空",align:Alignment.center);
        return;
      }
      print("66");
      print(_passwordController2.text.length.toString());
      if(_passwordController2.text.length != 11){
        BotToast.showText(text: "手机号需要11位",align:Alignment.center);
        return;
      }

      BlocProvider.of<ChangePwdBloc>(context).add(

        ForgetPwdButtonPressed(
          userCode:_passwordController1.text,
          mobile:_passwordController2.text,
        ),
      );
    }

    return BlocListener<ChangePwdBloc, ChangePwdState>(
      listener: (context, state) {
        if (state is ChangePwdFailure) {
          BotToast.showText(text: "${state.error}",align:Alignment.center);
        }
        else if(state is ChangePwdSuccess){
          //BlocProvider.of<AuthenticationBloc>(context).add(ReLogin());
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
            margin: EdgeInsets.only(top: 10),
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
//                                    suffix: GestureDetector(
//                                        onTap: (){
//                                          setState(() {
//                                            if(_isShow1==true)
//                                              _isShow1=false;
//                                            else
//                                              _isShow1=true;
//
//                                          });
//                                        },
//                                        child: Icon(
//                                          Icons.remove_red_eye,
//                                          color: !_isShow1 ? Theme.of(context).primaryColor : Colors.grey,
//                                        )
//                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _passwordController1,

                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 30,right: 30),
                              child: TextFormField(

                                keyboardType: TextInputType.number,
                                textInputAction:TextInputAction.done,
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.phone_iphone),
                                    labelText: '手机',
                                    contentPadding: EdgeInsets.all(10.0),
//                                    suffix: GestureDetector(
//                                        onTap: (){
//                                          setState(() {
//                                            if(_isShow2==true)
//                                              _isShow2=false;
//                                            else
//                                              _isShow2=true;
//
//                                          });
//                                        },
//                                        child: Icon(
//                                          Icons.remove_red_eye,
//                                          color: !_isShow2 ? Theme.of(context).primaryColor : Colors.grey,
//                                        )
//                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )

                                ),
                                style: TextStyle(fontSize: 18),
                                controller: _passwordController2,

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
