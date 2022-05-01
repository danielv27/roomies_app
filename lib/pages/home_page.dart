import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'roomies_page.dart';
import 'houses_page.dart';
import 'matches_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

//this is the underlying page for all states of the homepage ()
class HomePage extends StatefulWidget {
  @override
  ChangePageState createState() => ChangePageState();
}
  
class ChangePageState extends State<HomePage> {
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