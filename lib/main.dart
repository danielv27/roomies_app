import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
  );
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
    //resizeToAvoidBottomInset: false, //this prevents keyboard from pushing app up
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
         return LoginPage();
       }
     }
    ),
  );
}



