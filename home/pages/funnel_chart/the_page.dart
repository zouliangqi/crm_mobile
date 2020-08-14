import 'package:flutter/material.dart';
import 'package:miscrm/home/pages/funnel_chart/the_event.dart';

import 'the_bloc.dart';
import 'the_state.dart';
import "package:flutter/widgets.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import 'dart:convert';

//BlocProvider<FunnelBloc>(
//  create: (context) {
//    return FunnelBloc(
//      FunnelRepository: FunnelRepository).add(FunnelInitEvent());
//  },
//  child: FunnelPage(),
//),



class FunnelPage extends StatelessWidget {


  String tyname="默认商机阶段";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FunnelBloc, FunnelState>(builder: (context, state) {
      if (state is FunnelsuccessState) {
        List<PopupMenuItem<List>> x=[];
        state.success.forEach((e){
          x.add(
            PopupMenuItem<List>(value: [e["typeId"],e["name"]], child: Text(e["name"].toString(),style: TextStyle(fontSize: 14),)),
          );
        });
        List data=[];

        state.success2["list"].forEach((e){
//          String s=e["money"].toString();
//          var p=[];
//          if(s.length>3){
//            p=s.split('');
//          }
//          var q=[];
//          int ind=0;
//          p.forEach((e) {
//            if(ind==2){
//              q.add(e.toString());
//              q.add(',');
//            }
//            else
//              q.add(e.toString());
//          });
          data.add(
              json.encode({
                "name": e["name"].toString() + "(" + e["count"].toString() + ")",
                "value": double.parse(e["money"]),
                "label": {
                  "formatter": '{b}:  ${e["money"]}元'
                }
              })
          );
        });
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              //padding:EdgeInsets.only(top: 20) ,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 10, left: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
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
                                "仪表盘 —— 销售漏斗",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              itemBuilder: (BuildContext context) => x,
                              onSelected: (List value) {

                                BlocProvider.of<FunnelBloc>(context).add(FunnelInitEvent(id: value[0]));
                                tyname=value[1];
                              },
                            ),

                      ],
                    ),
                  ),
                //  Text("${state.success2.toString()}"),

                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("赢单：${state.success2["sumYing"]}",style: TextStyle(color: Colors.blueAccent),),
                        ),
                        Container(
                          child: Text("输单：${state.success2["sumShu"]}",style: TextStyle(color: Colors.redAccent),),
                        ),
                      ],
                    ),
                  ),

//                  Container(
//                      height: 400,
//                      child: getFunnelSmartLabelChart()
//                  ),

                  Center(child: Text("${tyname}")),
                Container(
                  height: 300,
                  width:MediaQuery.of(context).size.width,
                  child:Container(
                    child:

                    Echarts(
                      option: '''
                       {
                        tooltip: {
                          trigger: 'item'
                        },
                      calculable: true,
                       grid: {
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0
                      },
                      series: [
                      {    
                          type:'funnel',
                          left: '5%',
                          top: 10,
                          bottom: 60,
                          width: '40%',
                          maxsize: '100%',
                          minsize: '0%',
                          sort: 'none',
                          gap: 2,
                          label: {
                            normal: {
                              show: true,
                              position: 'right'
                            },
                            emphasis: {
                              textStyle: {
                                fontSize: 20
                              }
                            }
                          },
                          labelLine: {
                            normal: {
                              length: 20,
                              lineStyle: {
                                width: 1,
                                type: 'solid'
                              }
                            }
                          },
                          itemStyle: {
                              color: data => {
                              return [
                                '#6CA2FF',
                                '#6AC9D7',
                                '#72DCA2',
                                '#DBB375',
                                '#E164F7',
                                '#FF7474',
                                '#FFB270',
                                '#FECD51'
                              ][data.dataIndex % 8]
                            }
                          },
                          data: ${data}
                      }
                      ]
                    }
                      '''
                    ),
                    width: 300,
                    height: 250,
                  )
//                  Echarts(
//                      option :'''
//                      {
//                        title: {
//                          text: '漏斗图',
//                          subtext: '纯属虚构'
//                        },
//                        tooltip: {
//                          trigger: 'item',
//                          formatter: "{a} <br/>{b} : {c}%"
//                        },
//                        toolbox: {
//                          feature: {
//                            dataView: {readOnly: false},
//                            restore: {},
//                            saveAsImage: {}
//                          }
//                        },
//                        legend: {
//                          data: ['展现','点击','访问','咨询','订单']
//                        },
//
//                        series: [
//                          {
//                            name:'漏斗图',
//                            type:'funnel',
//                            left: '10%',
//                            top: 60,
//                            //x2: 80,
//                            bottom: 60,
//                            width: '80%',
//                            // height: {totalHeight} - y - y2,
//                            min: 0,
//                            max: 100,
//                            minSize: '0%',
//                            maxSize: '100%',
//                            sort: 'descending',
//                            gap: 2,
//                            label: {
//                              show: true,
//                              position: 'inside'
//                            },
//                            labelLine: {
//                              length: 10,
//                              lineStyle: {
//                                width: 1,
//                                type: 'solid'
//                              }
//                            },
//                            itemStyle: {
//                              borderColor: '#fff',
//                              borderWidth: 1
//                            },
//                            emphasis: {
//                              label: {
//                                fontSize: 20
//                              }
//                            },
//                            data: [
//                              {value: 60, name: '访问'},
//                              {value: 40, name: '咨询'},
//                              {value: 20, name: '订单'},
//                              {value: 80, name: '点击'},
//                              {value: 100, name: '展现'}
//                            ]
//                          }
//                        ]
//                      };''',
//                    extraScript: '''
//                    chart.on('click', (params) => {
//                      if(params.componentType === 'series') {
//                        Messager.postMessage(JSON.stringify({
//                          type: 'select',
//                          payload: params.dataIndex,
//                        }));
//                      }
//                    });
//                  ''',
////                    onMessage: (String message) {
////                      Map<String, Object> messageAction = jsonDecode(message);
////                      print(messageAction);
////                      if (messageAction['type'] == 'select') {
////                        final item = _data1[messageAction['payload']];
////                        _scaffoldKey.currentState.showSnackBar(
////                            SnackBar(
////                              content: Text(item['name'].toString() + ': ' + display(item['value'])),
////                              duration: Duration(seconds: 2),
////                            ));
////                      }
////                    },
//
//                  ),
                )


                ],
              ),
            ),




            //SfFunnelChart()
          ],
        );

      }
      else if(state is FunnelFailState){
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


