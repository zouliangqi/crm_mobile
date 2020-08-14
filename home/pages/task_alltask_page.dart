import 'package:flutter/material.dart';

/*class AllTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[

          Container(
            child: Row(
              children: <Widget>[

              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("hello"),
                Text("hello"),
                Text("hello"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/


import 'animation/dropDownItem.dart';
import '../models/filterButtonModel.dart';

class AllTaskPage extends StatefulWidget {
  @override
  _AllTaskPageState createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //dropDownItem.dart里面自定义的类，下拉筛选框
            DropDownFilter(
              buttons: [
                FilterButtonModel(
                  title: Text('任务类型'),
                  type: 'Cloumn',
                  contents: ['全部','我负责的','我参与的'],
                ),
                FilterButtonModel(
                  title: Text('任务状态'),
                  type: 'Column',
                  contents: ['全部','正在进行','已结束'],
                ),
                FilterButtonModel(
                  title: Text('优先级'),
                  type: 'Column',
                  contents: ['全部','高','中','低','无'],
                )
              ],
            ),

          ]
      ),
    );
  }
}