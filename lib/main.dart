import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'pages/roomies_page.dart';
import 'pages/houses_page.dart';
import 'pages/matches_page.dart';

bool loggedIn = true; //will use this to evaluate wether

void main() {
  runApp(App());
}

class App extends StatelessWidget {

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
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  ChangePageState createState() => ChangePageState();
}
  
class ChangePageState extends State<Home> {
    int _currentPage = 0;
  
  final pages = [
    const RoomiesPage(),
    const MatchesPage(),
    const HousesPage()
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: pages[_currentPage],
      bottomNavigationBar: Container(
        
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            
          ),
          borderRadius: const BorderRadius.all(Radius.circular(120))
        ),
        margin: const EdgeInsets.only(left: 36.0, right: 36.0, bottom: 18),


          child: BottomBar(
            selectedIndex: _currentPage,
            showActiveBackgroundColor: true,

            onTap: (int index) {
              
              setState(() => _currentPage = index);
            },
            items: <BottomBarItem>[
                /// Roomies
                BottomBarItem(
                  title: const Text('Roomies'),
                  icon: const Icon(Icons.person, size: 40,),
                  activeColor: const Color.fromARGB(255, 192, 58, 103),
                ),

                /// Matches
                BottomBarItem(
                  title: const Text('Matches'),
                  icon: const Icon(Icons.message, size: 40,),
                  activeColor: const Color.fromARGB(255, 192, 58, 103),
                ),

                /// Houses
                BottomBarItem(
                  title: const Text('Houses'),
                  icon: const Icon(Icons.house, size: 40,),
                  activeColor: const Color.fromARGB(255, 192, 58, 103),
                ),
            ],
          ),
      ),
    );
  }
}
enum _SelectedTab {roomies, matches, houses}


dynamic nextPageTransition(BuildContext context,Animation animation,Widget child){

  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  final tween = Tween(begin: begin,end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}


Route nextPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MatchesPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {  
      return nextPageTransition(context, animation, child);
    },
  );
}

// class MatchesPage extends StatelessWidget {
//   const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Matches'),
      ),
    );
  }
// }

Route housesPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HousesPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {  
      return nextPageTransition(context, animation, child);
    },
  );
}

// class HousesPage extends StatelessWidget {
//   const HousesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: const Center(
//         child: Text('Houses'),
//       ),
//     );
//   }
// }