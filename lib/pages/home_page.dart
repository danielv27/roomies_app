import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'roomies_page.dart';
import 'houses_page.dart';
import 'matches_page.dart';

//this is the underlying page for all states of the homepage ()
class HomePage extends StatefulWidget {
  @override
  ChangePageState createState() => ChangePageState();
}
  
class ChangePageState extends State<HomePage> {
  int _previousPage = 0;
  int _currentPage = 0;
  
  final pages = [
    RoomiesPage(),
    const MatchesPage(),
    const HousesPage(),
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
        margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 30),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2), 
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(120))
        ),
        child: BottomBar(
          selectedIndex: _currentPage,
          onTap: (int index) {
            _previousPage = _currentPage;
            setState(() => _currentPage = index);
          },
          //activeColor is a mandatory fiend but doesnt do anything as the bottom bar library was modified.
          items: <BottomBarItem>[
            /// Roomies
            BottomBarItem(
              title: const Text('Roomies', style: TextStyle(color: Colors.white),),
              icon: Image.asset('assets/icons/Profile-selected.png',height: 30,),
              activeColor: const Color.fromARGB(255, 192, 58, 103),
              inactiveIcon: Image.asset('assets/icons/Profile.png',height: 30,),
              inactiveColor: Colors.grey
            ),
            /// Matches
            BottomBarItem(
              title: const Text('Matches'),
              icon: Image.asset('assets/icons/Chat.png', height: 30,),
              activeColor: const Color.fromARGB(255, 192, 58, 103),
              inactiveColor: Colors.grey
            ),
            /// Houses
            BottomBarItem(
              title: const Text('Houses'),
              icon: Image.asset('assets/icons/Home-selected.png', height: 30,),
              activeColor: const Color.fromARGB(255, 192, 58, 103),
              inactiveColor: Colors.grey,
              inactiveIcon: Image.asset('assets/icons/Home.png', height: 30,),
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
