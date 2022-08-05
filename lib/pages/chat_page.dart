import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/messages_api.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/chat_page/chat_header.dart';
import 'package:roomies_app/widgets/chat_page/message_bubble_widget.dart';
import '../models/message.dart';
import '../widgets/chat_page/new_message_widget.dart';

class PrivateChatPage extends StatefulWidget {
  final UserModel otherUser;
  
  const PrivateChatPage({
      Key? key,
      required this.otherUser,
    }) : super(key: key);  

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  List<Message> messages = [];
  late final GlobalKey<AnimatedListState> _key = GlobalKey();
  
  @override
  void initState(){
    super.initState();
    
  }
  
  void _addMessage(Message message){
    messages.insert(0, message);
    if(_key.currentState != null){
      _key.currentState?.insertItem(0, duration: const Duration(milliseconds: 130));
      widget.otherUser.setLastMessage(message.message);
      widget.otherUser.setTimeStamp(message.timeStamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true ,
      body: Column(
        children: [
          ChatHeader(
            otherUser: widget.otherUser,
          ),
          Expanded(
            child: FutureBuilder(
              future: MessagesAPI().getPrivateMessages(FirebaseAuth.instance.currentUser?.uid, widget.otherUser.id),
              builder:(context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    messages = snapshot.data as List<Message>;
                    messages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                    MessagesAPI().listenToPrivateChat(FirebaseAuth.instance.currentUser?.uid, widget.otherUser.id)
                    ?.listen(
                      (event) {
                        print('listening');
                        List<Message>? newMessages = event;
                        if(newMessages != null && newMessages.length > messages.length){
                          newMessages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));

                          // need to add case of handling multiple messages sent quickly using newMessages.length - messages.length
                          newMessages[0].sentByCurrent ? null : _addMessage(newMessages[0]);
                        }
                      },
                    );
                    return AnimatedList(
                      key: _key,
                      padding: const EdgeInsets.only(bottom: 10),
                      initialItemCount: messages.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context,index, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: MessageBubbleWidget(message: messages[index]));
                      }
                    );
                  }
                }
                if (snapshot.hasError) {
                return const Text("Something went wrong");
                }
                return const Center(child: CircularProgressIndicator(color: Colors.red));
              } 
            ),
          ),
          NewMessageWidget(
            otherUser: widget.otherUser, 
            onMessageSent: (message) => _addMessage(Message(message: message, otherUserID: widget.otherUser.id, sentByCurrent: true, timeStamp: DateTime.now()))
          ),
        ],
      ),
    );
  }
}