import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/Auth/auth_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/screens/Auth/SignIn.dart';
import 'package:guidanclyflutter/screens/Auth/signup.dart';
import 'package:guidanclyflutter/screens/onboard/welcome.dart';
import 'package:guidanclyflutter/screens/splash/splash_screen.dart';
import 'package:guidanclyflutter/shared/constants/constants.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:guidanclyflutter/shared/theme/theme.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Sharednetwork.cashInitializer();
  accessToken = Sharednetwork.getDataString(key: "accessToken");
  runApp( const Guidancly());
}

class Guidancly extends StatefulWidget {
  const Guidancly({super.key});

  @override
  State<Guidancly> createState() => _GuidanclyState();
}

class _GuidanclyState extends State<Guidancly> {

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> Authcubit()),
        BlocProvider(create: (context) => LayoutCubit()..getUserData()),
      ],
      child: MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) =>  SplashScreen(token: accessToken ?? ""),
          '/welcome':(context) => const Welcome(),
          '/signIn':(context) => const SignIn(),
          '/signUp':(context) => const SignUp(),

        },
      ),
    );
  }
}
