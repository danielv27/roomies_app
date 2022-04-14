import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
      home: RoomiesPage(),
    );
  }
}

class RoomiesPage extends StatefulWidget {
  
  @override
  _RoomiesPageState createState() => _RoomiesPageState();
}
class _RoomiesPageState extends State<RoomiesPage> {
  var _selectedTab = _SelectedTab.roomies;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(housesPageRoute());
          },
          child: const Text('Houses'),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        unselectedItemColor: Colors.grey,
        onTap: _handleIndexChanged,
        items: [
            /// Roomies
            SalomonBottomBarItem(
              title: const Text('Roomies'),
              icon: const Icon(Icons.person, size: 40,),
              selectedColor: const Color.fromARGB(255, 192, 58, 103),
            ),

            /// Matches
            SalomonBottomBarItem(
              title: const Text('Matches'),
              icon: const Icon(Icons.message, size: 40,),
              selectedColor: const Color.fromARGB(255, 192, 58, 103),
            ),

            /// Houses
            SalomonBottomBarItem(
              title: const Text('Houses'),
              icon: const Icon(Icons.house, size: 40,),
              selectedColor: const Color.fromARGB(255, 192, 58, 103),
              
            ),
        ],
      ),
    );
  }
}
enum _SelectedTab {roomies, matches, houses}

//before changing navBar
// class RoomiesPage extends StatelessWidget {
//   const RoomiesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).push(housesPageRoute());
//           },
//           child: const Text('Houses'),
//         ),
//       ),
//       bottomNavigationBar: ElevatedButton(
//         child: const Text('Matches'),
//         onPressed: () {
//           Navigator.of(context).push(matchesPageRoute());
//         },
//       ),
//     );
//   }
// }


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


Route matchesPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MatchesPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {  
      return nextPageTransition(context, animation, child);
    },
  );
}

class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Matches'),
      ),
    );
  }
}

Route housesPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HousesPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {  
      return nextPageTransition(context, animation, child);
    },
  );
}

class HousesPage extends StatelessWidget {
  const HousesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Houses'),
      ),
    );
  }
}