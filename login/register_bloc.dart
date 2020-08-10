import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'register_repository.dart';
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({
    @required this.registerRepository,

  }) : assert(registerRepository != null);// : assert(registerRepository != null)

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterInit) {
      await registerRepository.registerGetUser();
    //  var dept= await registerRepository.registerGetDept();
      yield RegisterLoading();

    }
    else if(event is RegisterButtonPressed){
      yield RegisterLoading();

      await Future.delayed(Duration(milliseconds: 500));
     Map response= await registerRepository.register(
          username:event.username,
          realname:event.realname,
          password:event.password,
          deptId:event.deptId,
          mobile:event.mobile,
          sex:event.sex,
          email:event.email,
          post:event.post,
          parentId:event.parentId
      );

     if(response["code"]==500){
       yield RegisterFailure(error: response["msg"]);
     }
      else if(response["code"]==0)
       yield RegisterSuccess(success: "注册成功");
    }
  }
}

//event
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}



class RegisterButtonPressed extends RegisterEvent{
  final String username;
  final String realname;
  final String password;
  final int deptId;
  final String mobile;
  final int sex;
  final String email;
  final String post;
  final int parentId;

  const RegisterButtonPressed({
    @required this.username,
    @required this.realname,
    @required this.password,
    @required this.deptId,
    @required this.mobile,
    @required this.sex,
    @required this.email,
    @required this.post,
    @required this.parentId,
  });



  @override
  List<Object> get props => [username,realname, password,deptId,mobile,sex,email,post,parentId];

}

class RegisterInit extends RegisterEvent{
  final String kk;
  const RegisterInit({this.kk});

  @override
  List<Object> get props =>[kk];
}

//state
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}


class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String success;

  const RegisterSuccess({@required this.success});

  @override
  List<Object> get props => [success];

  @override
  String toString() => 'RegisterSuccess { success: $success }';
}
class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RegisterFailure { error: $error }';
}