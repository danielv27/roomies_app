import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/group_chat.dart';
import 'package:roomies_app/models/message.dart';

class ChatAPI {

  Future sendPrivateMessage(String message, String? fromID, String? toID) async {
    final fromRef = FirebaseFirestore.instance.collection('users/$fromID/private_chats').doc(toID);
    final toRef = FirebaseFirestore.instance.collection('users/$toID/private_chats').doc(fromID);
    try{
      final currentTime = DateTime.now();
      await fromRef.collection('messages').add({
        'message': message,
        'otherUserID': toID,
        'sentByCurrent': true,
        'timeStamp': currentTime
      });
      await fromRef.set({
        'last_message': message,
        'last_message_timestamp': currentTime
      });

      await toRef.collection('messages').add({
        'message': message,
        'otherUserID': fromID,
        'sentByCurrent': false,
        'timeStamp': currentTime
      });
      await toRef.set({
        'last_message': message,
        'last_message_timestamp': currentTime
      });

      print('message sent to firebase\n');
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }

  }

  Future<List<Message>?> getPrivateMessages(String? currentUserID, String? otherUserID) async {
    try {
      List<Message>? messages = [];
      await FirebaseFirestore.instance.collection('users/$currentUserID/private_chats/$otherUserID/messages')
      .get()
      .then((querySnapshot) {
        for (var messageDoc in querySnapshot.docs) {
          Message currentMessage = Message(
            message: messageDoc['message'],
            otherUserID: messageDoc['otherUserID'],
            sentByCurrent: messageDoc['sentByCurrent'],
            timeStamp: messageDoc['timeStamp'].toDate()
            );
          messages.add(currentMessage);
        }
      });
      return messages;
    } catch (e) {
      debugPrint("Error - $e");
      return null;  
    }
  }

  Stream<List<Message>?>? listenToPrivateChat(String? currentUserID, String? otherUserID) {
    try {
      return FirebaseFirestore.instance.collection('users/$currentUserID/private_chats/$otherUserID/messages')
      .snapshots()
      .map((querySanpshot) => querySanpshot.docs.map((messageDoc) => Message(
        message: messageDoc['message'],
        otherUserID: messageDoc['otherUserID'],
        sentByCurrent: messageDoc['sentByCurrent'],
        timeStamp: messageDoc['timeStamp'].toDate()
        )).toList());
    } catch (e) {
      debugPrint("Error - $e");
    }
    return null;
  }

  Future<String> getLastPrivateMessage(String? currentUserID, String? otherUserID) async {
    String lastMessage = '';
    await FirebaseFirestore.instance.doc('users/$currentUserID/private_chats/$otherUserID')
    .get()
    .then((documentSnapShot) {
      if(documentSnapShot.exists && documentSnapShot.data()!.containsKey('last_message')){
        lastMessage = documentSnapShot['last_message'];
      }
    });
    return lastMessage;
    
  }

  Future<DateTime?> getLastPrivateMessageTimeStamp(String? currentUserID, String? otherUserID) async {
    DateTime? timeStamp;
    await FirebaseFirestore.instance.doc('users/$currentUserID/private_chats/$otherUserID')
    .get()
    .then((documentSnapShot) {
      if(documentSnapShot.exists && documentSnapShot.data()!.containsKey('last_message_timestamp')){
        timeStamp = documentSnapShot['last_message_timestamp'].toDate();
      }
    });
    return timeStamp;
  }

  Future createGroupChat(String houseID,List<String> participants, String creatorID) async {
    try{
      if(participants.length > 1){
        print('creating');
        await FirebaseFirestore.instance.collection('group_chats').add({
          'houseID': houseID,
          'participants': participants,
          'madeBy': creatorID
        });
      }
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }
  }

  Future sendGroupMessage(String groupChatID, String senderID, String message) async {
    await FirebaseFirestore.instance.collection('group_chats/$groupChatID/messages').add({
      'meesage': message,
      'senderID': senderID,
      'timeStamp': DateTime.now()
    });
  }

  // this funtcion was tested it extracts the chats correctly for a given user corrently logged in
  Future<List<GroupChat>> getGroupChats() async {
    List<GroupChat> groupChats = [];
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('group_chats')
    .where('participants', arrayContains: currentUserID)
    .get()
    .then(
      (querySnapShot) {
        for(var groupChatDoc in querySnapShot.docs){
          // DateTime this = ''
          // String lastMessageSent = 
          // groupChatDoc.data().containsKey('lastMessageSent')?
          // groupChatDoc['lastMessageSent'] : '';
          // DateTime lastMessageTime = groupChatDoc
          // .data()
          // .containsKey('lastMessageTimeStamp')? groupChatDoc['lastMessageTimeStamp'] : '';
          // GroupChat chat = GroupChat(
          //   groupID: groupChatDoc.id,

          // );
        }
      }
    );
    return groupChats;
  }
}