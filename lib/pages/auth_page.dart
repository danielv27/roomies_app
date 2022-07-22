import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/pages/setup_page.dart';

import '../widgets/gradients/gradient.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() => AuthPageState();
}

// ignore: use_key_in_widget_constructors
class AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool _isChecked = false;
  bool _isHiddrenPassword = true;
  bool _isSignupPage = false;

  // @override
  // void initState() {
  //   _loadUserEmailPassword();
  //   super.initState();
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool invalidEmail = false;
  bool invalidPassword = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: redGradient(),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: redGradient(),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Image.asset("assets/images/app-icon.png"),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: SingleChildScrollView(
            child: BottomSheet(
              onClosing: () { },
              enableDrag: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0), 
                  topRight: Radius.circular(30.0)
                ),
              ),
              builder: (BuildContext context) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  child: AnimatedCrossFade(
                    firstChild: showLogin(), 
                    secondChild: showSignup(),
                    crossFadeState: _isSignupPage
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 400),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }



  Widget showLogin() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: emailSigninInputDecoration(),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.done,
            obscureText: _isHiddrenPassword,
            decoration: passwordInputDecoration(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              rememberMeGestureDetector(),
              const SizedBox(width: 10.0),
              const Text(
                "Remember Me",
                style: TextStyle(color: Color(0xff646464), fontSize: 14, fontFamily: 'Rubic'),
              ),
              const Spacer(),
              const Text( // TODO: add forget password functionality
                "Forgot Password",
                style: TextStyle(color: Color(0xff646464), fontSize: 12, fontFamily: 'Rubic'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            decoration: applyBlueGradient(),
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onSurface: Colors.transparent,
                minimumSize: const Size.fromHeight(42),
              ),
              onPressed: () {
                setState(() {
                  emailController.text.isEmpty ? invalidEmail = true : invalidEmail = false;
                  passwordController.text.isEmpty ? invalidPassword = true : invalidPassword = false;
                });
                if (emailController.value.text.isNotEmpty) {
                  signIn();
                } else {
                  print("Login button disabled since email field is empty");
                }
              }, 
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20, color:Colors.white)
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Don\'t have account? ',
              style: const TextStyle(
                color: Colors.grey,
              ),
              children: [  
                TextSpan(
                  recognizer: TapGestureRecognizer()
                  ..onTap = _toggleSignup,
                  style: const TextStyle(
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  text: 'Create account'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showSignup() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Create account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: firstNameController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: applyInputDecoration("First Name", Icons.person_rounded),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: lastNameController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: applyInputDecoration("Last Name", Icons.person_rounded)
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: emailController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            decoration: emailSignupInputDecoration("Email"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: passwordController,
            style: const TextStyle(color: Colors.grey),
            cursorColor: Colors.red,
            textInputAction: TextInputAction.done,
            obscureText: _isHiddrenPassword,
            decoration: passwordInputDecoration(),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              rememberMeGestureDetector(),
              const SizedBox(width: 10.0),
              const Text(
                "Remember Me",
                style: TextStyle(color: Color(0xff646464), fontSize: 12, fontFamily: 'Rubic'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            decoration: applyBlueGradient(),
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                onSurface: Colors.transparent,
                minimumSize: const Size.fromHeight(42),
              ),
              onPressed: () {
                setState(() {
                  emailController.text.isEmpty ? invalidEmail = true : invalidEmail = false;
                });
                if (emailController.value.text.isNotEmpty) {
                  signUp(); // User signup with firebase authentication
                  Navigator.push(
                    context, 
                    PageTransition(type: PageTransitionType.fade, child: const SetupPage()),
                  );
                } else {
                  print("Signup button disabled");
                }
              },
              child: const Text(
                "Create account",
                style: TextStyle(fontSize: 20, color:Colors.white)
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Already have an account? ',
              style: const TextStyle(
                color: Colors.grey,
              ),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                  ..onTap = _toggleSignup,
                  style: const TextStyle(
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  text: 'Login'
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector rememberMeGestureDetector() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        height: 20.0,
        width: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: _isChecked ? applyBlueLinearGradient() : null,
          border: _isChecked ? null : Border.all(color: const Color.fromRGBO(101, 101, 107, 1), width: 1.5,),
        ),
        child: _isChecked ? const Icon(
          Icons.check,
          size: 17,
          color: Colors.white,
        ) : null,
      ),
    );
  }

  InputDecoration emailSigninInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/Email.png'),
          height: 20,
          width: 20,
        ),
      ),
      labelText: "Email",
      labelStyle: const TextStyle(color: Colors.grey),
      errorText: invalidEmail ? 'Email Can\'t Be Empty' : null,
    );
  }

  InputDecoration passwordInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/Password.png'),
          height: 20,
          width: 20,
        ),
      ),
      labelText: "Password",
      labelStyle: const TextStyle(color: Colors.grey),
      errorText: invalidPassword ? "Invalid Password" : null,
      suffixIcon: InkWell(
        onTap: _togglePasswordView,
        child: Icon(
          _isHiddrenPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    );
  }

  InputDecoration emailSignupInputDecoration(String labelText) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/Email.png'),
          height: 20,
          width: 20,
        ),
      ),
      iconColor: Colors.grey,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      errorText: invalidEmail ? 'Email Can\'t Be Empty' : null,
    );
  }

  InputDecoration applyInputDecoration(String labelName, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(245, 247, 251, 1),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      labelText: labelName,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: const Align(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Image(
          image: AssetImage('assets/icons/person.png'),
          height: 15,
          width: 15,
        ),
      ),
    );
  }

  BoxDecoration applyBlueGradient() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.fromRGBO(0, 53, 190, 1), Color.fromRGBO(57, 103, 224, 1), Color.fromRGBO(117, 154, 255, 1)]
      )
    );
  }

  LinearGradient applyBlueLinearGradient() {
    return const LinearGradient(
      colors: [
        Color.fromRGBO(0, 53, 190, 1),
        Color.fromRGBO(57, 103, 224, 1),
        Color.fromRGBO(117, 154, 255, 1)
      ],
    );
  }

  Future signUp() async {
    FireStoreDataBase().createUser(emailController, passwordController, firstNameController, lastNameController);
  }

  Future signIn() async {
    FireStoreDataBase().signinUser(emailController, passwordController, context);
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddrenPassword = !_isHiddrenPassword;
    });
  }

  void _toggleSignup() {
    setState(() {
      _isSignupPage = !_isSignupPage;
      // removes error text under text fields when transitioning between signin and signup
      invalidEmail = false;
      invalidPassword = false;
    });
  }

}