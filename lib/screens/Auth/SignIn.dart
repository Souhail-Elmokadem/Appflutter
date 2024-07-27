import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool _isFocused1 = false;
  bool _isFocused2 = false;
  dynamic focusColor=Colors.deepPurpleAccent;

  bool securityPass=true;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 160),
          color: Colors.white,
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
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 430,
                  color: Colors.white,
                  child: TextFormField(
                    focusNode: _focusNode1,
                    decoration: InputDecoration(
                      hintText: "email",
                      filled: true,
                      fillColor: _isFocused1
                          ? const Color(0xffEBEBFF)
                          : const Color(0xfff7f7f9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 430,

                  color: Colors.white,
                  child: TextFormField(
                    obscureText: securityPass,

                    focusNode: _focusNode2,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(onPressed: (){
                          setState(() {
                            securityPass=!securityPass;
                          });
                        },icon: securityPass==true? const Icon(Icons.visibility):const Icon(Icons.visibility_off),color: Colors.black38,iconSize: 30,),
                      ),
                      hintText: "********",
                      filled: true,
                      fillColor: _isFocused2
                          ? const Color(0xffEBEBFF)
                          : const Color(0xfff7f7f9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 22, horizontal: 20),
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
                      )),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),

                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    setState(() {


                    });
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
                          color: Colors.white, fontFamily: 'sf-ui', fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
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
                            padding: EdgeInsets.zero, // Remove internal padding
                            minimumSize: Size(
                                0, 0), // Ensure no minimum size constraints
                          ),
                          child: const Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black38,
                              fontFamily: 'sf-ui',
                            ),
                          )),
                      TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Remove internal padding
                            minimumSize: Size(
                                0, 0), // Ensure no minimum size constraints
                          ),
                          child: const Text(
                            " Sign up",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.deepPurpleAccent,
                                fontFamily: 'sf-ui'),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () {},


                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove internal padding
                    minimumSize:
                        Size(0, 0), // Ensure no minimum size constraints
                  ),

                  child: const Text(
                    "Or connect with ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                      fontFamily: 'sf-ui',
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/gmail.png",
                    fit: BoxFit.cover,

                    // Ensure the image covers the entire CircleAvatar
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
