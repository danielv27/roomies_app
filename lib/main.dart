import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

bool loggedIn = true; //will use this to evaluate wether

void main() {
  runApp(
    const MaterialApp(
      home: RoomiesPage(),
    ),
  );
}

class RoomiesPage extends StatelessWidget {
  const RoomiesPage({Key? key}) : super(key: key);

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
      bottomNavigationBar: ElevatedButton(
        child: const Text('Matches'),
        onPressed: () {
          Navigator.of(context).push(matchesPageRoute());
        },
      ),
    );
  }
}

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