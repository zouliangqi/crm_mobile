

import 'package:equatable/equatable.dart';

class User extends Equatable{
  final deptName;
  final imgPath;
  final createTime;
  final lastLoginTime;
  final lastPwdUpdateTime;
  final num;
  final sex;
  final mobile;
  final realname;
  final parentName;
  final position;
  final userId;
  final parentId;
  final lastLoginIp;
  final deptId;
  final email;
  final username;
  final status;


  User({this.deptName, this.imgPath, this.createTime, this.lastLoginTime,
      this.lastPwdUpdateTime, this.num, this.sex, this.mobile, this.realname,
      this.parentName, this.position, this.userId, this.parentId,
      this.lastLoginIp, this.deptId, this.email, this.username, this.status});

  @override
  // TODO: implement props
  List<Object> get props => [
    deptName,imgPath,createTime,lastLoginTime,lastPwdUpdateTime,num,sex,
    mobile,realname,parentName,position,userId,parentId,lastLoginIp,deptId,email,username,status
  ];

  //提取所需Json片段里面的数据
  static User fromJson(dynamic json){
    final consolidatedUser = json['data'];
    return User(
      deptName: consolidatedUser['deptName'],
      imgPath: consolidatedUser['img'],
      createTime: consolidatedUser['createTime'],
      lastLoginTime: consolidatedUser['lastLoginTime'],
      lastPwdUpdateTime: consolidatedUser['lastPwdUpdateTime'],
      num: consolidatedUser['num'],
      sex: _mapSexToString(consolidatedUser['sex']),
      mobile: consolidatedUser['mobile'],
      realname: consolidatedUser['realname'],
      parentName: consolidatedUser['parentName'],
      position: consolidatedUser['post'],
      userId: consolidatedUser['userId'],
      parentId: consolidatedUser['parentId'],
      lastLoginIp: consolidatedUser['lastLoginIp'],
      deptId: consolidatedUser['deptId'],
      email: consolidatedUser['email'],
      username: consolidatedUser['username'],
      status: consolidatedUser['status'],
    );
  }

  static String _mapSexToString(int input){
    //服务器数据库表中性别表示 0->未知，1->男，2->女
    String gender;
    switch(input){
      case 1:
        gender = "男";
        break;
      case 2:
        gender = "女";
        break;
      default:
        gender = "未知";
    }
    return gender;
  }
}