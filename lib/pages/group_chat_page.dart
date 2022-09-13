import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/group_chat_page/input_field.dart';
import 'package:roomies_app/widgets/group_chat_page/message_bubble_widget.dart';
import '../models/message.dart';
import '../widgets/private_chat_page/input_field.dart';

class PrivateChatPage extends StatefulWidget {
  final GroupChat chat;
  
  const PrivateChatPage({
      Key? key,
      required this.chat,
    }) : super(key: key);

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
 
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<Message> messages = [];
  List<UserModel?> participants = [];

  void initialize() async {
    if(participants.isEmpty){
      for(var participantID in widget.chat.participantsIDs){
        final participant = await UsersAPI().getUserModelByID(participantID);
        participants.add(participant);
      }
    }
  }

  @override
  void initState(){
    super.initState();
    initialize();
  }
  
  void _addMessage(Message message){
    messages.insert(0, message);
    if(_key.currentState != null){
      _key.currentState?.insertItem(0, duration: const Duration(milliseconds: 130));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: true ,
      body: Column(
        children: [
          // GroupChatHeader(
          //   groupChat: widget.chat,
          // ),
          Expanded(
            child: FutureBuilder(
              future: ChatAPI().getGroupMessages(widget.chat.groupID),
              builder:(context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasData){
                    messages = snapshot.data as List<Message>;
                    messages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                    ChatAPI().listenToGroupChatMessages(widget.chat.groupID)
                    ?.listen(
                      (event) {
                        List<Message>? newMessages = event;
                        if(newMessages != null && newMessages.length > messages.length){
                          newMessages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
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
                          child: GroupMessageBubbleWidget(message: messages[index]));
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
          GroupChatInputField(
            otherUser: widget.otherUser, 
            onMessageSent: (message) => _addMessage(Message(message: message, otherUserID: widget.otherUser.id, sentByCurrent: true, timeStamp: DateTime.now()))
          ),
        ],
      ),
    );
  }
}