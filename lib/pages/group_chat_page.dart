import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/chat_api.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/user_model.dart';
import 'package:roomies_app/widgets/group_chat_page/chat_header.dart';
import 'package:roomies_app/widgets/group_chat_page/input_field.dart';
import 'package:roomies_app/widgets/group_chat_page/message_bubble_widget.dart';
import '../models/message.dart';

class GroupChatPage extends StatefulWidget {
  final GroupChat chat;
  final HouseProfileModel houseModel;
  final HouseSignupProfileModel houseSignUpProfileModel;
  
  const GroupChatPage({
      Key? key,
      required this.chat,
      required this.houseModel,
      required this.houseSignUpProfileModel
    }) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
 
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  String address = 'House';
  List<Message> messages = [];
  List<UserModel?> participants = [];

  Future initialize() async {
    
    if(participants.isEmpty){
      for(var participantID in widget.chat.participantsIDs){
        final participant = await UsersAPI().getUserModelByID(participantID);
        participants.add(participant);
      }
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
    
  }
  
  void _addMessage(Message message){
    messages.insert(0, message);
    if(_key.currentState != null){
      _key.currentState?.insertItem(0, duration: const Duration(milliseconds: 130));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialize(),
      builder:(context, snapshot) => snapshot.connectionState == ConnectionState.done ? Scaffold(
        resizeToAvoidBottomInset: true ,
        body: Column(
          children: [
            GroupChatHeader(
              chat: widget.chat,
              houseSignUpProfileModel: widget.houseSignUpProfileModel,
            ),
            Expanded(
              child: FutureBuilder(
                future: ChatAPI().getGroupMessages(widget.chat.id),
                builder:(context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      messages = snapshot.data as List<Message>;
                      messages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                      ChatAPI().listenToGroupChatMessages(widget.chat.id)
                      ?.listen(
                        (event) {
                          List<Message>? newMessages = event;
                          if(newMessages != null && newMessages.length > messages.length){
                            newMessages.sort((a, b) => b.timeStamp.toString().compareTo(a.timeStamp.toString()));
                            newMessages[0].otherUserID == FirebaseAuth.instance.currentUser?.uid ? null : _addMessage(newMessages[0]);
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
                          String senderName = "";
                          for(var participant in participants){
                            if(participant?.id == messages[index].otherUserID){
                              senderName = "${participant?.firstName} ${participant?.lastName}";
                            }
                          }
                          return SizeTransition(
                            sizeFactor: animation,
                            child: GroupMessageBubbleWidget(message: messages[index], groupImageURL: widget.chat.groupImage, senderName: senderName),
                          );
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
              groupChat: widget.chat, 
              onMessageSent: (message) => _addMessage(
                Message(
                  message: message,
                  otherUserID: FirebaseAuth.instance.currentUser!.uid,
                  sentByCurrent: true,
                  timeStamp: DateTime.now()
                )
              )
            ),
          ],
        ),
      ): const Scaffold(body: Center(child: CircularProgressIndicator(),))
    );
  }
}