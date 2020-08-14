import 'package:flutter/material.dart';
import 'package:miscrm/home/pages/task_alltask_page.dart';


 class TaskPage extends StatefulWidget {
   @override
   _TaskPageState createState() => _TaskPageState();
 }

 class _TaskPageState extends State<TaskPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{

   TabController _tabController;

   @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

   @override
  void initState() {

    super.initState();
  }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         elevation: 0,

         title: Text('新增'),

         actions: <Widget>[

         ],
         centerTitle: true,
         backgroundColor: Colors.white,
         bottomOpacity: 0.6,

       ),
       body: Center(
         child: Column(
           children: <Widget>[
             Image.asset("assets/im_loading.gif"),
             Text("新增功能还在优化中..."),
           ],
         ),
       ),

//       TabBarView(
//
//         controller: _tabController,
//         children: <Widget>[
//           ToDoPage(),
//           AllTaskPage(),
//
//         ],
//       )
     );
   }






 }
