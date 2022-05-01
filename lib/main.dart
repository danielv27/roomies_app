import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roomies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
     stream: FirebaseAuth.instance.authStateChanges(),
     
     builder: (context, snapshot) {
       if(snapshot.connectionState == ConnectionState.waiting) {
         return const Center(child: CircularProgressIndicator());
       }
       else if (snapshot.hasData) {
         return HomePage();
       }
       else {
         return Container(child: LoginWidget(), margin: const EdgeInsets.only(top: 200));
       }
     }
    ),
  );
}

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => LoginWidgetState();
}


class LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool invalidUserName = false;
  bool invalidPassword = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        const SizedBox(height: 20),
        TextField(
          controller: emailController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            icon: const Icon(Icons.email,size: 20),
            
            labelText: "Email",
            errorText: invalidUserName ? "Invalid Email" : null
            ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          obscureText: true,
          decoration: InputDecoration(
            icon: const Icon(Icons.lock,size: 20),
            labelText: "Password",
            errorText: invalidPassword ? "Invalid Password" : null
            ),
        ),
        
        const SizedBox(height: 20),
        
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent[400],
            minimumSize: const Size.fromHeight(50)
            
          ),
          icon: const Icon(Icons.lock_open, size: 32),
          label: const Text("Log In", style: TextStyle(fontSize: 24)), 
          onPressed: signIn,
          ),
      ]),
    );
  }
  
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );

    } on FirebaseAuthException catch (exc) {
      setState(() {
        if (exc.toString().contains('email') || exc.toString().contains('user')){
          invalidUserName = true;
        }
        if (exc.toString().contains('password')){
          invalidPassword = true;
        }
        // ignore: avoid_print
        print(exc.toString());
      });

    }

  }
}






