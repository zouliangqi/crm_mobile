import 'package:flutter/material.dart';

class ToDoPage extends StatelessWidget {
  String contactCustomer ;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.phone,color: Colors.white,),
            ),
            title: Text('今日需联系客户'),
            subtitle: contactCustomer != null ? Text('今日需联系客户 $contactCustomer 人'):Text("暂无今日需联系客户"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.all_inclusive,color: Colors.white,),
            ),
            title: Text('分配给我的线索'),
            subtitle: contactCustomer != null ? Text('分配给我的线索 $contactCustomer 条'):Text("暂无分配给我的线索"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.person_add,color: Colors.white,),
            ),
            title: Text('分配给我的客户'),
            subtitle: contactCustomer != null ? Text('分配给我的客户 $contactCustomer 人'):Text("暂无分配给我的客户"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.group_work,color: Colors.white,),
            ),
            title: Text('待进入公海的客户'),
            subtitle: contactCustomer != null ? Text('待进入公海的客户 $contactCustomer 人'):Text("暂无待进入公海的客户"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.library_books,color: Colors.white,),
            ),
            title: Text('即将到期的合同'),
            subtitle: contactCustomer != null ? Text('即将到期的合同 $contactCustomer 个'):Text("暂无即将到期的合同"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.playlist_add_check,color: Colors.white,),
            ),
            title: Text('待审核的合同'),
            subtitle: contactCustomer != null ? Text('待审核的合同 $contactCustomer 个'):Text("暂无待审核的合同"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.settings_backup_restore,color: Colors.white,),
            ),
            title: Text('待审核的回款'),
            subtitle: contactCustomer != null ? Text('待审核的回款 $contactCustomer 个'):Text("暂无待审核的回款"),
          ),
          Divider(height: 1,indent: 80,),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Icon(Icons.local_post_office,color: Colors.white,),
            ),
            title: Text('待审核的办公'),
            subtitle: contactCustomer != null ? Text('待审核的办公 $contactCustomer 个'):Text("暂无待审核的办公"),
          ),
        ],
      ),
    );
  }
}
