import 'package:flutter/material.dart';
import "dart:async";
import "package:flutter/widgets.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:miscrm/home/pages/sale_report/sale_bloc.dart';
import 'package:miscrm/home/pages/sale_report/sale_event.dart';
import 'package:miscrm/home/pages/sale_report/sale_reps.dart';
import 'package:miscrm/home/pages/sale_report/sale_state.dart';


class SaleList extends StatelessWidget {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SaleBloc, SaleState>(builder: (context, state) {
      //print(state.toString());
      if (state is SalesuccessState) {
        return Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Image(
                    image: AssetImage("assets/dashBoard.png",),
                    width: 18,
                    fit: BoxFit.cover,
                  ),),

                title: Text('仪表盘——销售简报',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20,0,20,10),
                child: Divider(height: 1,color: Colors.grey,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 120,
//                      color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.people_outline,
                          color: Colors.cyan,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('新增客户'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text:  state.success["data"]["customerCount"]
                                      .toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextSpan(text:'  个'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
//                      color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.perm_contact_calendar,
                          color: Colors.green,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('新联系人'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: state.success["data"]["contactsCount"].toString(),
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextSpan(text:'  个'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 120,
//                      color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blue,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('新增商机'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                    text: state.success["data"]["businessCount"].toString(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text:'  个'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
//                      color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.cloud,
                          color: Colors.amber,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('商机变化'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: state.success["data"]["recordStatusCount"].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextSpan(text:'  个'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 120,
//                      color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.chrome_reader_mode,
                          color: Colors.pinkAccent,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('新增合同'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: state.success["data"]["contractCount"]
                                      .toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextSpan(text:'  个'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
//                      color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.purpleAccent,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('新增回款'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: state.success["data"]["receivablesCount"]
                                      .toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextSpan(text:'  个'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 120,
                    //color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.assignment,
                          color: Colors.lightBlue,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('跟进记录'),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: state.success["data"]["recordCount"]
                                      .toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextSpan(text:'  条'),
                                ]
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        Icon(
//                          Icons.euro_symbol,
//                          color: Colors.deepOrange,
//                        ),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text('商机金额'),
//                            Text.rich(TextSpan(
//                                children: [
//                                  TextSpan(
//                                    text: state.success["data"]["recordStatusCount"].toString(),
//                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                  ),
//                                  TextSpan(text:'  元'),
//                                ]
//                            ))
//                          ],
//                        ),
//                      ],
//                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),
        );
        return Container(
          //margin: EdgeInsets.only(top: 5.0),
          child: Column(
            children: <Widget>[
//                Padding(
//                  padding: EdgeInsets.fromLTRB(20,0,20,10),
//                  child: Divider(height: 1,color: Colors.grey,),
//                ),

              Container(
                margin: EdgeInsets.only(top: 10),
                //padding:EdgeInsets.only(top: 20) ,
                decoration: BoxDecoration(
                  color: Colors.white,
//                            borderRadius:BorderRadius.only(
//                              topRight: Radius.elliptical(35,35),
//                              //bottomRight: Radius.elliptical(35,35),
//                              bottomLeft: Radius.elliptical(35,35),
//                              //topLeft: Radius.elliptical(35,35)
//                            ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Image(
                              image: AssetImage("assets/dashBoard.png",),
                              width: 18,
                              fit: BoxFit.cover,
                            ),),
                          Container(
                            margin: EdgeInsets.only(left: 30),
                            child: Text(
                              "仪表盘 —— 销售简报",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/1.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('新增客户'),
                            ],
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: state.success["data"]["customerCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            //TextSpan(text:'个'),
                          ]))
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/3.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('新增商机'),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                                text: state.success["data"]["businessCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/5.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('新增合同'),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                                text: state.success["data"]["contractCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/7.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('新增回款'),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                                text: state.success["data"]["receivablesCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/2.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('新增联系人'),
                            ],
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: state.success["data"]["contactsCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            //TextSpan(text:'个'),
                          ]))
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/4.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('阶段变化的商机'),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                                text: state.success["data"]["recordStatusCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 40),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/6.png"),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.grey,
                              SizedBox(
                                width: 10,
                              ),
                              Text('新增跟进记录'),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                                text: state.success["data"]["recordCount"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      }
      else if(state is SaleFailState){
        return Center(
          child: Text("${state.error}"),
        );
      }
      else return Center(
          child: Image.asset("assets/im_loading.gif"),
        );
    });
  }
}


