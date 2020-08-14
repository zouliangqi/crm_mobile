import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miscrm/config.dart';
import 'package:miscrm/customer/bloc/customer_bloc.dart';
import 'package:miscrm/customer/pages/customer_page.dart';
import 'package:miscrm/home/blocs/bloc.dart';
import 'package:miscrm/home/common/global.dart';
import 'package:miscrm/home/models/profile_model.dart';
import 'home_page.dart';
import 'task_page.dart';
import 'package:miscrm/business/business_page.dart';
import 'user_page.dart';


 class IndexPage extends StatefulWidget {

   _IndexPageState createState() => _IndexPageState();
 }

 class _IndexPageState extends State<IndexPage>{


   @override
   void initState() {

     initialize();//用户信息初始化到config文件中
//     currentPage=tabBodies[currentIndex];
     timeDilation = 1.0;  //将动画时间改回默认1.0，因为登陆页面改动了这个顶级属性
     super.initState();

   }
   initialize() async{

     profile = await homeInit();//保存配置信息到config文件里面

     if(profile.token != null && profile.token != ""){
       myToken = profile.token;
       print("the token is $myToken");
     }

   }
//    initialize() async{
//
//      profile = await homeInit();//保存配置信息到config文件里面
//
//     if (profile.msg != null && profile.msg != ""){
//       print("index_page msg is : ${profile.msg}");
//       //return null;
//     }else if(profile.token != null && profile.token !=""){
//       Mytoken = profile.token;
//       print("index_page profile instance's token is: ${profile.token}");
//       //print(profile.toString());
//       //return profile;
//     }
//
//   }

   final List<BottomNavigationBarItem> bottomTabs = [
     BottomNavigationBarItem(
//       icon:Image(
//         image: AssetImage("assets/home.png",),
//         width: 22,
//         fit: BoxFit.cover,
//       ),
       icon: Icon(
//         CupertinoIcons.home,
       Icons.business,
//         size: 28,
       ),
       title:Text('首页',),
//       activeIcon: Container(
//         color: Colors.blue,
//         child: Image(
//           width: 25,
//           image: AssetImage("assets/home.png",),
//           color: Colors.white,
//           fit: BoxFit.cover,
//
//         ),
//       ),
       //Icon(Icons.home,color: Color(0xFF39619E),),
     ),
     BottomNavigationBarItem(
//         icon:Image(
//           image: AssetImage("assets/customer.png",),
//           width: 22,
//           fit: BoxFit.cover,
//         ),
//         activeIcon:Image(
//           width: 25,
//           image: AssetImage("assets/customer.png",),
//           color: Color(0xFF39619E),
//           fit: BoxFit.cover,
//
//         ),
        icon: Icon(
          Icons.people_outline,
//          CupertinoIcons.pe
//          size: 28,
        ),
         title:Text('客户',)
     ),
//     BottomNavigationBarItem(
//       icon:Container(
//           width: 40,
//           height: 40,
//           child:Image(
//             image: AssetImage("assets/addingnew.png",),
//             fit: BoxFit.cover,
//           ),
//       ),
//       title: Container()
//     ),
     BottomNavigationBarItem(
//         icon:Image(
//           image: AssetImage("assets/business.png",),
//           width: 22,
//           fit: BoxFit.cover,
//         ),
//         activeIcon:Image(
//           width: 25,
//           image: AssetImage("assets/business.png",),
//           color: Color(0xFF39619E),
//           fit: BoxFit.cover,
//         ),
         icon: Icon(
           Icons.lightbulb_outline,
//           size: 28,
         ),
         title:Text('商机',)
     ),
     BottomNavigationBarItem(
//          icon:Image(
//            image: AssetImage("assets/my.png",),
//            width: 22,
//            fit: BoxFit.cover,
//          ),
//          activeIcon:Image(
//            width: 25,
//            image: AssetImage("assets/my.png"),
//            color: Color(0xFF39619E),
//            fit: BoxFit.cover,
//          ),
         icon: Icon(
           Icons.person_outline,
//           size: 28,
         ),
          title:Text('我的',)
     ),
   ];

   final List<Widget> tabBodies = [
     HomePage(),
     BlocProvider(
       create: (context){
         return CustomerBloc();
       },
       child: CustomerPage(),
     ),
//     TaskPage(),
     BusinessPage(),
     BlocProvider(
       create: (context){
         return HomeBloc();
          // ..add(FetchUserDetail());
       },
       child: UserPage(),
     ),
   ];

   final PageController _pageController = PageController();
   int currentIndex= 0;
//   var currentPage ;


   @override
   Widget build(BuildContext context) {
//     timeDilation = 1;
     //ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
//     return Scaffold(
//       body: Center(
//         child: Text("test"),
//       ),
//     );

     return Scaffold(
       backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
       bottomNavigationBar: BottomNavigationBar(
         backgroundColor: Colors.white,
         type: BottomNavigationBarType.fixed,
         currentIndex: currentIndex,
         items:bottomTabs,
         onTap: (index){
           //setState(() {
           //currentIndex=index;
           //currentPage =tabBodies[currentIndex];

           _pageController.jumpToPage(index);
           //});

         },
       ),
       //body: currentPage,
       body: PageView(
         controller: _pageController,
         onPageChanged: (index){

           setState(() {
             currentIndex = index;
           });
         },
         children: tabBodies,
       ),
     );
   }


 }


