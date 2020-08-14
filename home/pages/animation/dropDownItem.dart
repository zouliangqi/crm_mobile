import 'package:flutter/material.dart';
import '../../models/filterButtonModel.dart';


class DropDownFilter extends StatefulWidget {

  final Widget otherWidget;//页面除了筛选按钮部分Widget 新车页：列表
  final List<FilterButtonModel> buttons; //按钮数组 数据类型是FilterButtonModel
  DropDownFilter({Key key, this.otherWidget, this.buttons});

  @override
  _DropDownFilterState createState() => _DropDownFilterState();
}

class _DropDownFilterState extends State<DropDownFilter> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double innerHeight = 150.0;
  bool isMask = false; //下拉蒙层是否显示
  FilterButtonModel curButton;
  int curFilterIndex;

  initState() {
    // TODO: implement initState
    super.initState();
    //初始化下拉列表
    curButton = widget.buttons[0];

    controller = new AnimationController(
      duration: const Duration(milliseconds: 200), 
      vsync: this
    );

    animation = new Tween(begin: 0.0, end: innerHeight).animate(controller)
    ..addListener(() {
      //这行如果不写，没有动画效果
      setState(() {});
    });
  }

  void ontap () {
    controller.reverse();
    triggerTextColor(widget.buttons[curFilterIndex]);
    triggerIcon(widget.buttons[curFilterIndex]);
    triggerMask();
  }

  void triggerMask () {
    setState(() {
      isMask = !isMask;
    });
  }

  void triggerIcon (btn) {
    if(btn.direction == 'up') {
      btn.direction = 'down';
    } else {
      btn.direction = 'up';
    }
  }

  //btn 为传人按钮列表的按钮实例，按钮为filterButtonModel类型
  int lastIndex ;//记录筛选按钮实例的哈希值，用于对比两次点击的按钮是否一样
  void triggerTextColor(btn){
    //print("btn is : ${btn.hashCode}");
    if(lastIndex == btn.hashCode){
      //print("本次点击的筛选按钮和上一次的按钮一样");
      if(btn.title.style==null){

        //print(btn.title);
        btn.title=Text(btn.title.data,style: TextStyle(color: Theme.of(context).primaryColor),);

      }else{
        //print(btn.title);
        btn.title=Text(btn.title.data,);
      }
    }else{
      //print("本次点击的筛选按钮和上一次的按钮不一样");
      widget.buttons.forEach(
              (button){
                //print("现在的按钮列表：$button");
                button.title=Text(button.title.data);
                //print("修改后的按钮列表：$button");
              });
      //点击新按钮，给新按钮样式赋值
      btn.title=Text(btn.title.data,style: TextStyle(color: Theme.of(context).primaryColor),);
      lastIndex = btn.hashCode;
    }


}
  //初始化按钮状态
  void initButtonStatus () {
    widget.buttons.forEach((i) {
      setState(() {
        i.direction = 'down';
      });
    });
  }

  //更新数据
  void updateData (i) {
    setState(() {
      curButton = widget.buttons[i];
      curFilterIndex = i;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack( //stack设置为overflow：visible之后，内部的元素中超出的部分就不能触发点击事件；所以尽量避免这种布局
        children: <Widget>[
          Column(
            children: <Widget>[
              _button(),
              // widget.otherWidget
            ],
          ),
          _contentList(curButton),
          
        ],
      )
    );
  }

  //筛选按钮
  Widget _button() {
    return Row(
      children: List.generate(widget.buttons.length, (i) {
        final thisButton = widget.buttons[i];
        return Container(
          //margin: EdgeInsets.only(right: 1),
          height: 50,
          width: MediaQuery.of(context).size.width / widget.buttons.length,
          child: FlatButton(
//            padding: EdgeInsets.only(top: 0, left: 10),
            child: Container(
              //color: Colors.deepOrange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  thisButton.title,//是Text组件类型
                  _rotateIcon(thisButton.direction)
                ],
              ),
            ),
            onPressed: () {
              //处理 下拉列表打开时，点击别的按钮
              if(isMask && i != curFilterIndex) {
                initButtonStatus();
                triggerTextColor(widget.buttons[i]);
                triggerIcon(widget.buttons[i]);
                updateData(i);
                return;
              }

              updateData(i);

              if(curButton.callback == null) {
                if(animation.status == AnimationStatus.completed) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
                triggerMask();
              } else {
                curButton.callback();
              }
              triggerTextColor(widget.buttons[i]);
              triggerIcon(widget.buttons[i]);
            },
          ),
        );
      }),
    );
    
  }

  //筛选弹出的下拉列表
  Widget _contentList(FilterButtonModel lists) {
    if(lists.contents != null && lists.contents.length > 0 ) {
      return Positioned(
          width:  MediaQuery.of(context).size.width,
          top: 50,
          left: 0,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: animation.value,
                child: _innerConList(lists)
              ),
              _mask()
            ],
          )
          
      );
    } else {
      return Container(height: 0,);
    }
  }
  //下拉列表内部组件布局
  Widget _innerConList(FilterButtonModel lists) {
    if(lists.type == 'Row') {
      setState(() {
        innerHeight = 50.0 * lists.contents.length;
      });
      
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Wrap(
          alignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          runSpacing: 15,
          children: List.generate(lists.contents.length, (i) {
            return GestureDetector(
              onTap: ontap,
              child: Container(
                width: (MediaQuery.of(context).size.width - 20) / 3, //每行显示3个
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(216,216,216,0.3),
                  ),
                  child: Text(lists.contents[i]),
                )
              )
            ); 
          }),
        )
      );
    } else {
      setState(() {
        innerHeight = 50.0 * lists.contents.length;
      });
      return ListView(
        children: List.generate(lists.contents.length, (i) {
          return GestureDetector(
            onTap: ontap,
            child: Container(
              height: 50,
              padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
              child: Text(lists.contents[i],style: TextStyle(
              
              ),),
            )
            
          );
        }),
      );
    }
  }

  //筛选的黑色蒙层
  Widget _mask() {
    if(isMask) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      );
    } else {
      return Container( 
        height: 0,
      );
    }
  }

  //右侧旋转箭头组建
  Widget _rotateIcon(direction) {
    if(direction == 'up') {
      return Container(
        //color: Colors.lightBlueAccent,
        child: Icon(
            Icons.keyboard_arrow_up,
            //color: Theme.of(context).primaryColor
        ),
      );
    } else {
      return Container(
        //color: Colors.lightBlueAccent,
        child: Icon(
            Icons.keyboard_arrow_down,
            //color: Theme.of(context).primaryColor
        ),
      );
    }
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
