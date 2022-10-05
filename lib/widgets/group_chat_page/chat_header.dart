import 'package:flutter/material.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/widgets/gradients/gradient.dart';

class GroupChatHeader extends StatelessWidget {
  final GroupChat chat;
  final HouseSignupProfileModel houseSignUpProfileModel;
  
  const GroupChatHeader({
    Key? key,
    required this.chat,
    required this.houseSignUpProfileModel
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      gradient: CustomGradient().redGradient(),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:14.0,right: 14.0,top: 10,bottom: 10),
        child: AppBar(
          leading: GestureDetector(
            onTap:() { 
              Navigator.pop(context);
            },
            child:  Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4), // border color
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 16,)),
            )
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: Column(
            children:  [
              Text("${houseSignUpProfileModel.streetName}\n${houseSignUpProfileModel.houseNumber}", style: const TextStyle(fontSize: 18),textAlign: TextAlign.center,),
              const SizedBox(height: 3),
            ],
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.red,
              backgroundImage: NetworkImage(chat.groupImage),
              radius: 26,
            ),
          ],
        ),
      ),
    );
  }
}