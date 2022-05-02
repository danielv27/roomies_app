import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
    const HousesPage(),
  ];
  
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(239, 85, 100, 1),
              Color.fromRGBO(195, 46, 66, 1),
              Color.fromRGBO(190, 40, 62, 1),
              Color.fromRGBO(210, 66, 78, 1),
              Color.fromRGBO(244, 130, 114, 1),
              ]
            )
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 400,
            title: Text(user.email!),
            actions: <Widget>[
              IconButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.settings_applications_sharp, size: 32,),
              ),
            ],
          ),
        ),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) => pageTransition(context,primaryAnimation,child, _currentPage, _previousPage),
        child: pages[_currentPage],
        ),
      extendBody: true,
      bottomNavigationBar: Container(
        
        margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 30),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black,)],
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(120))
        ),
        child: BottomBar(
          selectedIndex: _currentPage,
          //showActiveBackgroundColor: true,

          onTap: (int index) {
            _previousPage = _currentPage;
            setState(() => _currentPage = index);
          },
          
          //activeColor is a mandatory fiend but doesnt do anything as the bottom bar library was modified.
          items: <BottomBarItem>[
              /// Roomies
              BottomBarItem(
                title: const Text('Roomies', style: TextStyle(color: Colors.white),),
                icon: const Icon(Icons.person, size: 36,color: Colors.white,),
                activeColor: Colors.white,
                inactiveIcon: const Icon(Icons.person, size: 36,color: Colors.grey),
                inactiveColor: Colors.grey
              ),

              /// Matches
              BottomBarItem(
                title: const Text('Matches'),
                icon: const Icon(Icons.message, size: 36,),
                activeColor: const Color.fromARGB(255, 192, 58, 103),
                inactiveColor: Colors.grey
              ),

              /// Houses
              BottomBarItem(
                title: const Text('Houses'),
                icon: const Icon(Icons.house, size: 36,),
                activeColor: const Color.fromARGB(255, 192, 58, 103),
                inactiveColor: Colors.grey

              
                
              ),
              
              // BottomBarItem(
              //   title: const Text('Settings'),
              //   icon: const Icon(Icons.settings, size: 36,),
              //   activeColor: const Color.fromARGB(255, 192, 58, 103),
              // ),
                
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