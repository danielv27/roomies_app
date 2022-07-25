import 'dart:async';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/current_house_provider.dart';
import 'package:roomies_app/backend/current_profile_provider.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/backend/matches_provider.dart';
import 'package:roomies_app/backend/user_profile_provider.dart';
import 'package:roomies_app/pages/owner_page.dart';
import 'backend/setup_completion_provider.dart';
import 'pages/home_page.dart';
import 'pages/auth_page.dart';


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
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
     
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasData) {
          FireStoreDataBase().goOnline();
          return ChangeNotifierProvider(
            create: (context) => SetUpCompletionProvider(),  
            child: const UserTypeSelector()
          );
        }
        else {
          return AuthPage();
        }
      }
    ),
  );
}

class UserTypeSelector extends StatefulWidget {
  const UserTypeSelector({ Key? key }) : super(key: key);

  @override
  State<UserTypeSelector> createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  @override
  void initState() {
    super.initState();
    Provider.of<SetUpCompletionProvider>(context, listen: false).checkIfSetUpComplete().listen((event){});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<SetUpCompletionProvider>();
    if (userProvider.houseSetUp) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CurrentHouseProvider(),
          ),
        ],
        child: const OwnerPage(),
      );
    } else if (userProvider.profileSetUp) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserProfileProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CurrentUserProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => MatchesProvider() 
          ),
        ],
        child: const HomePage()
      );
    } else {
      return const Center(child: CircularProgressIndicator(color: Colors.red)); 
    }
  }
}


