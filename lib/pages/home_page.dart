import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:roomies_app/backend/providers/current_profile_provider.dart';
import 'package:roomies_app/backend/providers/matches_provider.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/widgets/bottom_bar.dart';
import '../models/user_model.dart';
import 'chat_page.dart';
import 'new_match_page.dart';
import 'roomies_page.dart';
import 'houses_page.dart';
import 'matches_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  ChangePageState createState() => ChangePageState();
}
  
class ChangePageState extends State<HomePage> with WidgetsBindingObserver {
  int _previousPage = 0;
  int _currentPage = 0;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.detached || state == AppLifecycleState.paused){
      UsersAPI().goOffline(FirebaseAuth.instance.currentUser?.uid);
    }
    else{
      UsersAPI().goOnline();
      
    }
  }


  @override
  Widget build(BuildContext context) {
    

    final pages = [
      RoomiesPage(),
      const MatchesPage(),
      const HousesPage()
    ];

    Provider.of<MatchesProvider>(context, listen: false).listenToMatches().listen((otherUser) {
      print('new match');
      final UserModel? currentUser = context.read<CurrentUserProvider>().currentUser?.userModel;
      UsersAPI().addMatch(currentUser!.id, otherUser.id);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 150),
          child: NewMatchPage(
            currentUser: currentUser,
            otherUser: otherUser,
            startChat: () {
              setState(() {
                _currentPage = 1;
              });
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: ChatPage(otherUser: otherUser),
                  type: PageTransitionType.rightToLeft,
                  curve: Curves.easeIn,
                )
              );
            },
            keepSwiping: () {
              // setState(() {
              //   _currentPage = 0;
              // });
              Navigator.pop(context);
            },
          ),
        )
      );
    });

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
          height: MediaQuery.of(context).size.height * 0.1,
          selectedIndex: _currentPage,

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
          onTap: (int index) {
            _previousPage = _currentPage;
            setState(
              () => _currentPage = index 
            );
          },
        ),
      ),
    );
  }
}


dynamic pageTransition(BuildContext context,Animation animation,Widget child, int currentPage, int previousPage){
  
  var begin = const Offset(1.0, 0.0);
  if(currentPage < previousPage){
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
