import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/Auth/auth_cubit.dart';
import 'package:guidanclyflutter/cubit/Auth/auth_state.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/screens/Auth/SignIn.dart';
import 'package:guidanclyflutter/screens/Auth/Widget_Input_number.dart';
import 'package:guidanclyflutter/screens/Auth/signup.dart';
import 'package:guidanclyflutter/screens/guide/dashboard/dashboard.dart';
import 'package:guidanclyflutter/screens/home/home.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:page_transition/page_transition.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class SignWithNumber extends StatefulWidget {
  const SignWithNumber({super.key});

  @override
  State<SignWithNumber> createState() => _SignInState();
}

class _SignInState extends State<SignWithNumber> {
  final TextEditingController txtnumberController = TextEditingController();
  final TextEditingController txtpassController = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool _isFocused1 = false;
  bool _isFocused2 = false;
  bool _isTxtNumberValid = false;
  bool securityPass = true;
  final focusColor = Colors.deepPurpleAccent;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        _isFocused1 = _focusNode1.hasFocus;
      });
    });
    _focusNode2.addListener(() {
      setState(() {
        _isFocused2 = _focusNode2.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    txtnumberController.dispose();
    txtpassController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          child: Image.asset("assets/img/loader.gif"),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<Authcubit, AuthState>(
          listener: (context, state) async {
            if (state is SignInLoading) {
              _showLoadingDialog(context);
            } else if (state is SignInSuccess) {
              _showSnackBar(context, "Sign In Successful", mainColor);
              await BlocProvider.of<LayoutCubit>(context).getUserData();//here layoutcubit
              final userdata = await BlocProvider.of<LayoutCubit>(context).user;
              if(state.role=="GUIDE"){
    if (userdata != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child:  Dashboard(guideModel: userdata,),
                    type: PageTransitionType.fade,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                  ModalRoute.withName('/'),
                );}else{
      print("Guide data is null");
      _showErrorDialog(context, "Guide data is not available.");
    }
              }else if(state.role == "VISITOR"){
                if (userdata != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      child: Home(visitorModel: userdata),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    ),
                    ModalRoute.withName('/'),
                  );
                } else {
                  // Handle the case where visitor data is null (perhaps show an error or a default page)
                  print("Visitor data is null");
                  _showErrorDialog(context, "Visitor data is not available.");
                }
              }

            } else if (state is SignInFailure) {
              Navigator.of(context).pop();
              _showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.only(top: 160),
              color: Colors.white,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Sign in now\n\n",
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'sf-ui',
                              color: Colors.black87,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: "Please sign in to continue our app",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'sf-ui',
                              color: Colors.black38,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        width: 430,
                        color: Colors.white,
                        child: PhoneNumberInput(
                          controller: txtnumberController,
                          onInputValidated: (v) {
                            setState(() {
                              _isTxtNumberValid = v;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        width: 430,
                        color: Colors.white,
                        child: TextFormField(
                          controller: txtpassController,
                          obscureText: securityPass,
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length < 8) {
                              return "Password required 8 characters";
                            }
                            return null;
                          },
                          focusNode: _focusNode2,
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    securityPass = !securityPass;
                                  });
                                },
                                icon: Icon(securityPass
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: Colors.black38,
                                iconSize: 30,
                              ),
                            ),
                            hintText: "********",
                            filled: true,
                            fillColor: _isFocused2
                                ? const Color(0xffEBEBFF)
                                : const Color(0xfff7f7f9),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.5),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget Password ?",
                            style: TextStyle(
                                fontSize: 16, color: Colors.deepPurpleAccent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (formKey.currentState!.validate() &&
                              _isTxtNumberValid) {
                            BlocProvider.of<Authcubit>(context).signInWithNumber(
                                number: txtnumberController.text,
                                password: txtpassController.text);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 430,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: focusColor,
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'sf-ui',
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.5),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: const Text(
                                "Don’t have an account? ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                  fontFamily: 'sf-ui',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const SignUp(),
                                    type: PageTransitionType.bottomToTop,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeIn,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: const Text(
                                " Sign up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepPurpleAccent,
                                  fontFamily: 'sf-ui',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text(
                        "Or connect with ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black38,
                          fontFamily: 'sf-ui',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buttonsSignIn(
                      name: "email",
                      icon: Icons.email,
                      function: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const SignIn(),
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    buttonsSignIn(
                      name: "Google",
                      img: "assets/img/google.png",
                      function: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buttonsSignIn({
    required String name,
    IconData? icon,
    String? img,
    required void Function() function,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        width: 430,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 30),
            if (img != null) Image.asset(img, fit: BoxFit.cover, width: 30),
            const SizedBox(width: 10),
            Text(
              "Continue with $name",
              style: const TextStyle(
                color: fourColor,
                fontFamily: 'sf-ui',
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
