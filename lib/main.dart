import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'pages/roomies_page.dart';
import 'pages/houses_page.dart';
import 'pages/matches_page.dart';

bool loggedIn = true; //will use this to evaluate wether

void main() {
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
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

