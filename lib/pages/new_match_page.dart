import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/gradients/gradient_text.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_gradient_border.dart';

import '../widgets/new_match_page/pop_in_animation.dart';

class NewMatchPage extends StatelessWidget {
  final UserModel? currentUser;
  final UserModel? otherUser;
  final VoidCallback startChat;
  final VoidCallback keepSwiping;
  
  const NewMatchPage({
    Key? key,
    required this.currentUser,
    required this.otherUser,
    required this.startChat,
    required this.keepSwiping
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: redGradient()),
        child: Column(children: [
          const Spacer(flex: 2),
          Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 120),
                child: PopInAnimation(
                  delay: const Duration(milliseconds: 230),
                  duration: const Duration(milliseconds: 1200),
                  explodeLeft: true,
                  child: AvatarWithGradientBorder(image: NetworkImage(currentUser!.firstImgUrl),radius: 66,backgroundColor: Colors.red,borderWidth: 5.5),
                )
              ),
              PopInAnimation(
                delay: const Duration(milliseconds: 290),
                duration: const Duration(milliseconds: 1200),
                explodeLeft: false,
                child: AvatarWithGradientBorder(image: NetworkImage(otherUser!.firstImgUrl),radius: 66,backgroundColor: Colors.red,borderWidth: 5.5),
              )
            ]
          ),
          const Spacer(),
          Text(
            "IT'S A MATCH!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 45,
              fontFamily: 'bergenText',
              fontWeight: FontWeight.w700
              ),
            ),
          const SizedBox(height: 20,),
          const Text(
            'Say hello to your potentially new\nroom mate!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'bergenText',
              fontSize: 16  
            ),
            
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => startChat(),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.85, MediaQuery.of(context).size.height *0.068)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
            ),
            child: GradientText(
              'Start Chat',
              gradient: redGradient(),
              style: const TextStyle(
                fontSize: 16,

              ),
              // style: const TextStyle(), TODO
            )
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => keepSwiping(),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.85, MediaQuery.of(context).size.height *0.068)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(120, 255, 255, 255))
            ),
            child: const Text(
              'Keep Swiping',
              style: TextStyle(
                fontSize: 16
              ),
            )
          ),
          const Spacer()
        ]),
      ),
      backgroundColor: Colors.white
    );
  }
}