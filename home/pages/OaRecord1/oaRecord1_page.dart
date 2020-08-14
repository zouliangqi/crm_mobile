import 'package:flutter/material.dart';
import "dart:async";
import "package:flutter/widgets.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'oaRecord1_bloc.dart';
import 'oaRecord1_event.dart';
import 'oaRecord1_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';





class OaRecord1List extends StatelessWidget {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    void _onRefresh() async{
      await Future.delayed(
          Duration(milliseconds: 1000),
              ()=>BlocProvider.of<OaRecord1Bloc>(context).add(OaRecord1ListEvent(pageIndex: 1))
      );
      _refreshController.refreshCompleted();
    }
    return BlocBuilder<OaRecord1Bloc, OaRecord1State>(builder: (context, state) {
      //print(state.toString());
      if (state is OaRecord1ListSuccessState) {

        int l=state.success.length+1;
        return Scrollbar(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              waterDropColor: Theme.of(context).primaryColor,
              refresh: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                strokeWidth: 2,),
              //idleIcon: Icon(Icons.refresh,color: Colors.white,),
              complete: Icon(Icons.check,color: Theme.of(context).primaryColor,),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: l,
                itemBuilder: (context, i) {
                  if(i==state.success.length){
                    if (state.hasReachedMax == false){

                        BlocProvider.of<OaRecord1Bloc>(context).add(OaRecord1ListEvent());

                      return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16.0),
                          child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                      );  //底部加载中指示器
                    }else{
                      return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16.0),
                          child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                      );
                    }
                  }
                  else
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            state.success[i]["userImg"] != null &&state.success[i]["userImg"].toString().isNotEmpty
                                ? Container(
                              //margin: EdgeInsets.fromLTRB(20, 25, 15, 25),
                              width: 30,
                              height: 30,
//                                width:
//                                70+containerGrowAnimation.value *10,
                              // height: containerGrowAnimation.value * 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  state.success[i]
                                  ["userImg"],
                                  //  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                                : Container(
                              //margin: EdgeInsets.fromLTRB(20, 25, 15, 25),
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                border: Border.all(
                                    width: 1, color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Text(
                                state.success[i]["realname"]
                                    .toString()
                                    .substring(1), //从字符串下标索引为1的字母开始一直到最后
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(state.success[i]
                                    ["realname"]
                                        .toString()),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      state.success[i]
                                      ["actionContent"]
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  state.success[i]["createTime"]
                                      .toString(),
                                  style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(
                              "今日工作内容：\n\t    ${state.success[i]["content"].toString()}",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )),
                        state.success[i]["tomorrow"]==null
                            ?Container()
                            :Container(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(
                              "明日工作内容：\n\t    ${state.success[i]["tomorrow"].toString()}",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )),
                        state.success[i]["question"]==null
                            ?Container()
                            :Container(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(
                              "遇到的问题：\n\t    ${state.success[i]["question"].toString()}",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )),
                        Divider()
                      ],
                    );
                }

            ),
          ),
        );

    }
      else if(state is OaRecord1ListFailState){
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


