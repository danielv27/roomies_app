import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool invalidUserName = false;
  bool invalidPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(239, 85, 100, 1),
              Color.fromRGBO(195, 46, 66, 1),
              Color.fromRGBO(190, 40, 62, 1),
              Color.fromRGBO(210, 66, 78, 1),
              Color.fromRGBO(244, 130, 114, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            const Image(
              image: AssetImage('assets/images/app-icon.png'),
              height: 100,
            ),
            Container(padding: const EdgeInsets.all(20)),
            const Spacer(),
            BottomSheet(
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
          ],
        ),
      ),
    );
  }

  Container showLogin() {
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
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.grey,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: const Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.grey,
                            ),
                            iconColor: Colors.grey,
                            fillColor: Colors.grey,
                            labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: invalidUserName ? "Invalid Email" : null
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.red,
                          textInputAction: TextInputAction.done,
                          obscureText: _isHiddrenPassword,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: const Icon(
                              Icons.lock,
                              size: 20,
                              color: Colors.grey,
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: invalidPassword ? "Invalid Password" : null,
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: const Icon(
                                Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: (Colors.grey)),
                                child: Checkbox(
                                  activeColor: Colors.red,
                                  value: _isChecked,
                                  onChanged: _handleRemember),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: Color(0xff646464), fontSize: 12, fontFamily: 'Rubic'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              shadowColor: Colors.red[900],
                              elevation: 5,
                              primary: Colors.white,
                              minimumSize: const Size.fromHeight(42),
                            ),
                            icon: const Icon(
                              Icons.lock_open,
                              size: 24,
                              color: Colors.red,
                            ),
                            label: const Text("Login", style: TextStyle(fontSize: 20, color: Colors.red)),
                            onPressed: signIn,
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
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  backgroundColor: Colors.white
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

  Container showSignup() {
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
                        TextField(
                          controller: firstNameController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.grey,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.grey,
                            ),
                            iconColor: Colors.grey,
                            fillColor: Colors.grey,
                            labelText: "First name",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: firstNameController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.grey,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.grey,
                            ),
                            iconColor: Colors.grey,
                            fillColor: Colors.grey,
                            labelText: "Last name",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.grey,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: const Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.grey,
                            ),
                            iconColor: Colors.grey,
                            fillColor: Colors.grey,
                            labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: invalidUserName ? "Invalid Email" : null
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.grey,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: const Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.grey,
                            ),
                            iconColor: Colors.grey,
                            fillColor: Colors.grey,
                            labelText: "Confirm email",
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: invalidUserName ? "Invalid Email" : null
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.grey),
                          cursorColor: Colors.red,
                          textInputAction: TextInputAction.done,
                          obscureText: _isHiddrenPassword,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            icon: const Icon(
                              Icons.lock,
                              size: 20,
                              color: Colors.grey,
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.grey),
                            errorText: invalidPassword ? "Invalid Password" : null,
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: const Icon(
                                Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Theme(
                                data: ThemeData(unselectedWidgetColor: (Colors.grey)),
                                child: Checkbox(
                                  activeColor: Colors.red,
                                  value: _isChecked,
                                  onChanged: _handleRemember),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: Color(0xff646464), fontSize: 12, fontFamily: 'Rubic'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              shadowColor: Colors.red[900],
                              elevation: 5,
                              primary: Colors.white,
                              minimumSize: const Size.fromHeight(42),
                            ),
                            icon: const Icon(
                              Icons.lock_open,
                              size: 24,
                              color: Colors.red,
                            ),
                            label: const Text("Create account",
                              style: TextStyle(fontSize: 20, color: Colors.red)),
                            onPressed: signIn,
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
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  backgroundColor: Colors.white
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

  
  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      focusColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.white),
      labelText: labelText,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }


  Future signIn() async {
    // Navigator.pop(context);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (exc) {
      setState(() {
        if (exc.toString().contains('email') ||
            exc.toString().contains('user')) {
          invalidUserName = true;
        }
        if (exc.toString().contains('password')) {
          invalidPassword = true;
        }
        // ignore: avoid_print
        print(exc.toString());
      });
    }
  }

  void _handleRemember(bool? checkboxState) {
    print("Handle Remember Me");

    _isChecked = checkboxState!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", checkboxState);
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      },
    );
    setState(() {
      _isChecked = checkboxState;
    });
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _rememberMe = _prefs.getBool("remember_me") ?? false;

      print(_rememberMe);
      print(_email);
      print(_password);

      if (_rememberMe) {
        setState(() {
          _isChecked = true;
        });
        emailController.text = _email;
        passwordController.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddrenPassword = !_isHiddrenPassword;
    });
  }

  void _toggleSignup() {
    setState(() {
      _isSignupPage = !_isSignupPage;
    });
  }

}