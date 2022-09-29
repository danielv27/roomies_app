import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/user_model.dart';
  
  class GroupChatInputField extends StatefulWidget {
    final GroupChat groupChat;
    final Function(String) onMessageSent;
    
    const GroupChatInputField({
      Key? key,
      required this.groupChat,
      required this.onMessageSent
      }) : super(key: key);

    @override
    GroupChatInputFieldState createState() => GroupChatInputFieldState();

  }

  class GroupChatInputFieldState extends State<GroupChatInputField> {
    final controller = TextEditingController();
    String message = ''; 

    void sendMessage() async {
      await ChatAPI().sendGroupMessage(widget.groupChat.groupID, FirebaseAuth.instance.currentUser!.uid, message);
      setState(() {
        widget.onMessageSent(message); 
      });
      message = '';
      controller.clear();
    }
   
    @override
    Widget build(BuildContext context) {

      return Container(
        
        decoration: BoxDecoration(
          color: Colors.white,
          
          borderRadius: const BorderRadius.all(Radius.circular(120)),
          
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2), 
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 15,right:15,bottom: 22),
        padding: const EdgeInsets.only(top:9.0,bottom: 9,right: 9,left: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                
                onChanged: (value) {
                  setState(() {
                    message = value;
                    
                  });
                },
                decoration: const InputDecoration(
                  isCollapsed: true,
                  alignLabelWithHint: false,
                  border: InputBorder.none,
                  labelText: 'Type something...',
                  focusColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Color.fromARGB(195, 48, 48, 52),
                    fontSize: 15
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never
                ),
              )
            ),
            GestureDetector(
              onTap:() =>  message.trim().isNotEmpty ? {sendMessage()} : null, //if doesnt work change to onMessageSent() 
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  gradient:LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color.fromRGBO(0, 53, 190, 1), Color.fromRGBO(57, 103, 224, 1), Color.fromRGBO(117, 154, 255, 1)]
                  ),
                  color: Colors.blue, // border color
                  shape: BoxShape.circle,
                ),
                
                child: Image.asset('assets/icons/Send.png',scale: 3.5,),
              ),
            ),
          ],
        ),
      );
    }
  }