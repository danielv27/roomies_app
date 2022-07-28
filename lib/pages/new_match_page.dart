import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';

class NewMatchPage extends StatelessWidget {
  final UserModel? currentUser;
  final UserModel? otherUser;
  final VoidCallback? startChat;
  final VoidCallback? keepSwipping;
  
  const NewMatchPage({
    Key? key,
    required this.currentUser,
    required this.otherUser,
    this.startChat,
    this.keepSwipping
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text('${currentUser!.firstName} ${currentUser!.lastName}'),
        Text('${otherUser!.firstName} ${otherUser!.lastName}'),
        ElevatedButton(onPressed: () =>  startChat!(), child: Container(color: Colors.blue,child: const Text('start chat'),)),
        ElevatedButton(onPressed: () =>  keepSwipping!(), child: Container(color: Colors.blue,child: const Text('keep swipping'),))
      ]),
      backgroundColor: Colors.white
    );
  }
}