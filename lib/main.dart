import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'pages/roomies_page.dart';
import 'pages/houses_page.dart';
import 'pages/matches_page.dart';

bool loggedIn = true; //will use this to evaluate wether

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
         return Center(child: CircularProgressIndicator(),);
       }
       else if(snapshot.hasError){
         return Center(child: Text('Wrong email or password'),);
       }
       else if (snapshot.hasData) {
         return Home();
       }
       else {
         return Container(child: LoginWidget(), margin: EdgeInsets.only(top: 200));
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        const SizedBox(height: 20),
        TextField(
          controller: emailController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        
        const SizedBox(height: 10),
        
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
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
      print(exc);
    }

  }
}




class Home extends StatefulWidget {
  @override
  ChangePageState createState() => ChangePageState();
}
  
class ChangePageState extends State<Home> {
  int _previousPage = 0;
  int _currentPage = 0;
  
  final pages = [
    const RoomiesPage(),
    const MatchesPage(),
    const HousesPage()
  ];

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email!),
        actions: <Widget>[
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout, size: 32,),
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) => pageTransition(context,primaryAnimation,child, _currentPage, _previousPage),
        child: pages[_currentPage],
        ),
      extendBody: true,
      bottomNavigationBar: Container(
        
        margin: const EdgeInsets.only(left: 35.0, right: 35.0, bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(120))
        ),
        child: BottomBar(
          selectedIndex: _currentPage,
          showActiveBackgroundColor: true,

          onTap: (int index) {
            _previousPage = _currentPage;
            setState(() => _currentPage = index);
          },
          
          items: <BottomBarItem>[
              /// Roomies
              BottomBarItem(
                title: const Text('Roomies'),
                icon: const Icon(Icons.person, size: 36,),
                activeColor: const Color.fromARGB(255, 192, 58, 103),
              ),

              /// Matches
              BottomBarItem(
                title: const Text('Matches'),
                icon: const Icon(Icons.message, size: 36,),
                activeColor: const Color.fromARGB(255, 192, 58, 103),
              ),

              /// Houses
              BottomBarItem(
                title: const Text('Houses'),
                icon: const Icon(Icons.house, size: 36,),
                activeColor: const Color.fromARGB(255, 192, 58, 103),
                
              ),
          ],
        ),
      ),
    );
  }
}


dynamic pageTransition(BuildContext context,Animation animation,Widget child, int _currentPage, int _previousPage){
  
  var begin = const Offset(1.0, 0.0);
  if(_currentPage < _previousPage){
    begin = const Offset(-1.0, 0.0);
  }
  const end = Offset.zero;
  const curve = Curves.easeOutCubic;

  final tween = Tween(begin: begin,end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}


// Route nextPageRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const MatchesPage(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {  
//       return pageTransition(context, animation, child);
//     },
//   );
// }

