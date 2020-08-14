import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:url_launcher/url_launcher.dart';

class OaRecord3Detial extends StatelessWidget {
  Map detail;

  OaRecord3Detial({this.detail});
  //附件预览
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    String content=detail["annContent"];

//    RegExp r=new RegExp('<img src=".*?">');
//    List imgList=[];
//    Iterable<Match> ma = r.allMatches(detail["annContent"]);
//    for (Match m in ma) {
//      String a=m.group(0).substring(10,m.group(0).length-2);
//      //print(a);
//      imgList.add(a);
//    }
//    print(imgList);

//    RegExp  reg=new RegExp('<.*?>');
////    print(reg.firstMatch(content).group(0));
//    Iterable<Match> matches = reg.allMatches(detail["annContent"]);
//    for (Match m in matches) {
//      content=content.replaceAll('${m.group(0)}', '\n');
//    }
//    content=content.replaceAll('&nbsp;&nbsp;', '  ');
    return Scaffold(
      appBar: AppBar(
        title: Text("公告详情"),
        elevation: 0,
        backgroundColor: Colors.white
        ,
        centerTitle: true,
      ),
      body: ListView(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Text(detail["title"].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text(detail["createTime"],style: TextStyle(fontSize: 13,color: Colors.grey),),
                Divider(),
//                Wrap(
//                  crossAxisAlignment: WrapCrossAlignment.start,
//                  children: <Widget>[
//                    Text(content),
//                  ],
//                ),
              ],
            ),
          ),

          Container(
            //margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 20,right: 20),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Html(
                data:detail["annContent"],
              //Optional parameters:
              backgroundColor: Colors.white70,
              onLinkTap: (url) {
                // open url in a webview
              },
              onImageTap: (src) {
              // Display the image in large form.
            },


            ),
          ),
          detail["file"]==null || detail["file"].toString()=="[]"
              ?Container()
              :Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: detail["file"].map<Widget>((e)=>
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: <Widget>[
                        e["name"]
                            .toString()
                            .length <= 20
                            ? Text(e["name"].toString())
                            : Text(
                            e["name"].toString().substring(
                                0, 20) + "..."),
                        Container(

                          padding: EdgeInsets.only(left: 7,
                              right: 7,
                              top: 3,
                              bottom: 3),
                          decoration: new BoxDecoration(
                            color: Color(0xFF39619E),
                            //color: Theme.of(context).primaryColor,
                            //gradient: const LinearGradient(colors: [Color(0xFF0FE3FF),Color(0xFF00A8E7),Color(0xFF1472FF),Color(0xFF1473FF)]),
                            borderRadius: new BorderRadius
                                .all(
                                const Radius.circular(8.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.7
                              ),
//            BoxShadow(color: Color(0x9900FF00),
//                offset: Offset(1.0, 1.0)
//            ),
//            BoxShadow(color: Color(0xFF0000FF)
//            )
                            ],

                          ),
                          child: InkWell(
                            onTap: () {
                              _launchURL(e["filePath"]);
                            },
                            child: Text("下载",
                              style: TextStyle(
                                  color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  )
              ).toList(),
            ),
          ),

        ],
      ),
    );
  }
}