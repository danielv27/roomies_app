import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';
import 'package:roomies_app/widgets/matches_page/avatar_with_gradient_border.dart';

class NewMatchPage extends StatelessWidget {
  final UserModel? currentUser;
  final UserModel? otherUser;
  final VoidCallback startChat;
  final VoidCallback keepSwipping;
  
  const NewMatchPage({
    Key? key,
    required this.currentUser,
    required this.otherUser,
    required this.startChat,
    required this.keepSwipping
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: redGradient()),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 210),
            child: Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 120),
                  child: AnimatedScale( // make statefull add animation in
                    scale: 1,
                    duration: const Duration(microseconds: 30000),
                    curve: Curves.elasticInOut,
                    child: AvatarWithGradientBorder(image: NetworkImage(currentUser!.firstImgUrl),radius: 66,backgroundColor: Colors.red,))),
                AvatarWithGradientBorder(image: NetworkImage(otherUser!.firstImgUrl),radius: 66,backgroundColor: Colors.red,)
              ]
            ),
          ),
          const Spacer(),
          Text(
            "IT'S A MATCH!",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 30
              ),
            ),
          const SizedBox(height: 20,),
          const Text(
            'Say hello to your potentially new\nroom mate!',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => startChat(),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.75, MediaQuery.of(context).size.height *0.064)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)
            ),
            child: const Text(
              'Start Chat',
              style: TextStyle(color: Colors.red),
            )
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => keepSwipping(),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width *0.75, MediaQuery.of(context).size.height *0.064)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(120, 255, 255, 255))
            ),
            child: const Text(
              'Keep Swipping'
            )
          ),
          const Spacer()
        ]),
      ),
      backgroundColor: Colors.white
    );
  }
}