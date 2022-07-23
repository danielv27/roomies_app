import 'dart:async';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/current_profile_provider.dart';
import 'package:roomies_app/backend/database.dart';
import 'package:roomies_app/backend/matches_provider.dart';
import 'package:roomies_app/backend/user_profile_provider.dart';
import 'package:roomies_app/pages/owner_page.dart';
import 'backend/user_type_provider.dart';
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
            create: (context) => UserTypeProvider(),  
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
    Provider.of<UserTypeProvider>(context, listen: false).getCurrentUserType();
      
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserTypeProvider>();
    Provider.of<UserTypeProvider>(context, listen: false).checkIfUserSetUpProfile().listen((event){});
    if (userProvider.isHouseOwner == "true") {
      return const OwnerPage();
    } else if (userProvider.isHouseOwner == "false" && userProvider.profileSetUp) {
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
          ChangeNotifierProvider(
            create: (context) => UserTypeProvider() 
          ),
        ],
        child: const HomePage()
      );
    } else {
      
      return const Center(child: CircularProgressIndicator(color: Colors.blue)); 
    }
  }
}


