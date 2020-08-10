
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miscrm/login/user_repository.dart';
import 'package:miscrm/login/authen_bloc.dart';

import 'package:miscrm/login/pages/login.dart';
import 'package:miscrm/login/pages/home.dart';
import 'package:miscrm/login/pages/splash.dart';

import 'package:bot_toast/bot_toast.dart';
import 'config.dart';
import 'home/common/global.dart';
import 'home/pages/setting_page.dart';
import 'login/pages/update_password.dart';
import 'routers/routers.dart';
import 'routers/application.dart';
import 'package:fluro/fluro.dart';
import 'home/pages/index_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  //BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  final userRepository = UserRepository();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: MyApp(userRepository: userRepository),
    ),
  );
}


class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final router = Router();
    Routers.configureRoutes(router);//引入Routes（路由总体配置），完成路由配置
    Application.router=router;

    return BotToastInit(
              child: MaterialApp(

                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('zh','CN'),
                  const Locale('en','US'),
                ],
                title: 'Edison CRM',
                navigatorObservers: [BotToastNavigatorObserver()],
                onGenerateRoute: Application.router.generator,
                theme: new ThemeData(
                  //scaffoldBackgroundColor: Color(0x0539619E),
                  primaryColor: Colors.blue,//Color(0xFF39619E)
                    //cardColor:Color(0xFF39619E),
                    //accentColor:Color(0xFF39619E),
                  appBarTheme: AppBarTheme(
                    color: Colors.white,
                    elevation: 0,
                    iconTheme: IconThemeData(
                      color: Colors.black
                    ),
                    actionsIconTheme: IconThemeData(
                      color: Colors.black
                    ),
                    textTheme: TextTheme(
                      title: TextStyle(color: Colors.black,fontSize: 22,),
                    ),
                  ),

                ),

                home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is AuthenticationAuthenticated){
                      return IndexPage();
                    }
                    if (state is AuthenticationUnauthenticated) {
                      return LoginPage(userRepository: userRepository);
                    }
                    if (state is AuthenticationLoading) {
                      CircularProgressIndicator();
                    }
                    if (state is UpdatePwd) {
                     return updatePwdPage();
                    }
                    return SplashPage();
                  },
                ),
              ),
        );
  }
}
