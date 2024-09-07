import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/Auth/auth_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/visitor/visitor_cubit.dart';
import 'package:guidanclyflutter/screens/Auth/SignIn.dart';
import 'package:guidanclyflutter/screens/Auth/signup.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour_cotes.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour_details.dart';
import 'package:guidanclyflutter/screens/guide/create_tour/create_tour_page.dart';

import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:guidanclyflutter/screens/onboard/welcome.dart';
import 'package:guidanclyflutter/screens/splash/splash_screen.dart';
import 'package:guidanclyflutter/screens/widgets/restart_widget.dart';
import 'package:guidanclyflutter/shared/constants/constants.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';
import 'package:guidanclyflutter/shared/theme/theme.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Sharednetwork.cashInitializer();
  accessToken = Sharednetwork.getDataString(key: "accessToken");
  runApp(RestartWidget(child: const Guidancly()) );
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
        BlocProvider(create: (context)=> TourCubit()..getTours()..getToursPopular()),
        BlocProvider(create: (context)=> VisitorCubit()),
        ChangeNotifierProvider<CreateTour>(
          create: (_) => CreateTour(),
        ),
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
          '/createTour':(context) =>  CreateTourPage(),
          '/createTourCotes':(context) => CreateTourCotes(),
          '/createTourdetails':(context) => CreateTourDetails(),

        },
      ),
    );
  }
}
