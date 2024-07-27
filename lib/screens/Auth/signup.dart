import 'package:flutter/material.dart';
import 'package:guidanclyflutter/screens/Auth/SignIn.dart';
import 'package:guidanclyflutter/screens/Auth/signInWithNumber.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = true;

  @override
  void initState() {
    super.initState();

    _fullnameFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _confirmPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 160),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Sign up now\n\n",
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'sf-ui',
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: "Please sign up to start using our app",
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
                SizedBox(height: 80),
                _buildTextField(
                  controller: _fullnameController,
                  focusNode: _fullnameFocusNode,
                  hintText: 'Full Name',
                ),
                SizedBox(height: 25),
                _buildTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 25),
                _buildPasswordField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  hintText: 'Password',
                ),
                SizedBox(height: 25),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  hintText: 'Confirm Password',
                  validator: _validateConfirmPassword,
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                _buildSignUpButton(),
                SizedBox(height: 25),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: focusNode.hasFocus ? const Color(0xffEBEBFF) : const Color(0xfff7f7f9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: _isPasswordVisible,
      validator: validator ?? _validatePassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black38,
          ),
          iconSize: 30,
        ),
        hintText: hintText,
        filled: true,
        fillColor: focusNode.hasFocus ? const Color(0xffEBEBFF) : const Color(0xfff7f7f9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        if (_formKey.currentState?.validate() ?? false) {
          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match')),
            );
          } else {
            // Handle successful sign up logic here
            print('Sign up successful');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields correctly')),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurpleAccent,
        ),
        child: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'sf-ui',
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
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
                "Already have an account?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Or connect with ",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black38,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/gmail.png",
              fit: BoxFit.cover,
                // Adjust width as needed
            ),
          ],
        ),
      ],
    );
  }
}
