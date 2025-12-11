import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/resourses/router_manager.dart';
import 'package:movie_app/core/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/feature/firebase/firebase_service.dart';
import 'config/theme/theme_manager.dart';
import 'feature/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String _initialRoute;

Future<void> _loadInitialState() async {

  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  if (!hasSeenOnboarding) {
    _initialRoute = AppRoutes.splashScreen;
  }
  else if (FirebaseAuth.instance.currentUser != null) {
    _initialRoute = AppRoutes.homeScreen;
  } else {
    _initialRoute = AppRoutes.login;
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await _loadInitialState();

  if(FirebaseAuth.instance.currentUser!=null){
    UserModel.currentUser= await FirebaseServices.getUserFromFireStore(FirebaseAuth.instance.currentUser!.uid);
  }

  runApp(MovieApp(startRoute: _initialRoute));
}


class MovieApp extends StatelessWidget{
  final String startRoute;

  const MovieApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 841),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: startRoute,
          theme: ThemeManager.light,
          darkTheme: ThemeManager.dark,
          locale: Locale("en"),
          supportedLocales: [Locale("en"), Locale("ar")],
        );
      },
      child: SizedBox.shrink(),
    );
  }
}



