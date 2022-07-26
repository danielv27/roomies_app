import 'package:flutter/material.dart';
import 'package:roomies_app/models/user_model.dart';

class NewMatchPage extends StatelessWidget {
  final UserModel currentUser;
  final UserModel otherUser;
  final VoidCallback? startChat;
  
  const NewMatchPage({
    Key? key,
    required this.currentUser,
    required this.otherUser,
    this.startChat
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}