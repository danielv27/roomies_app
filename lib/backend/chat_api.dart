import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/backend/users_api.dart';
import 'package:roomies_app/models/chat_models.dart';
import 'package:roomies_app/models/house_profile_model.dart';
import 'package:roomies_app/models/message.dart';
import 'package:roomies_app/models/user_model.dart';

class ChatAPI {

  Future createPrivateChat(String currentUserID, String otherUserID) async {
    final ref = FirebaseFirestore.instance.doc('users/$currentUserID/private_chats/$otherUserID');
    try{
      await ref.set({
        'last_message': '',
        'last_message_timestamp': DateTime.now()
      });
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }

  }

  Future<List<PrivateChat>> getPrivateChats() async {
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
    final List<UserModel> matches = await UsersAPI().getMatches(currentUserID!);
    final chats = await FirebaseFirestore.instance.collection('users/$currentUserID/private_chats')
    .get()
    .then((querySnapShot) => querySnapShot.docs.map(
      (documentSnapShot) {
        UserModel? otherUser = matches.firstWhere((user) => user.id == documentSnapShot.id,orElse: () => matches[0]);
        return PrivateChat(
          id: documentSnapShot.id,
          lastMessage: documentSnapShot['last_message'],
          lastMessageTime: documentSnapShot['last_message_timestamp'].toDate(),
          otherUser: otherUser,
        );
      }
    ).toList());
    return chats;
  }


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

  Stream<List<PrivateChat>?> streamPrivateChatChanges(List<UserModel> matches){

    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance.collection('users/$currentUserID/private_chats')
    .orderBy('last_message_timestamp',descending: true)
    .snapshots(includeMetadataChanges: true)
    .map((querySnapShot) => querySnapShot.docs.map((documentSnapShot) => PrivateChat(
      id: documentSnapShot.id,
      lastMessage: documentSnapShot['last_message'],
      lastMessageTime: documentSnapShot['last_message_timestamp'].toDate(),
      otherUser: matches.firstWhere((user) => user.id == documentSnapShot.id, orElse: () => matches[0])
    )).toList());
  }

  Stream<List<Message>?>? listenToPrivateChatMessages(String? currentUserID, String? otherUserID) {
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
      if(participants.length > 2){
        await FirebaseFirestore.instance.collection('group_chats').add({
            'house_id': houseID,
            'participants': participants,
            'made_by': creatorID,
            'last_message': '',
            'last_message_timestamp': DateTime.now()
        }).then((groupChat){
          groupChat.collection('messages').add({
            'message': '__HOUSE_INFO_MESSAGE_BUBBLE__',
            'timeStamp': DateTime.now(),
            'senderID': FirebaseAuth.instance.currentUser?.uid,
          });         
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
      'timeStamp': DateTime.now(),
    });
    await FirebaseFirestore.instance.doc('group_chats/$groupChatID').set({
      'last_message': DateTime.now(),
      'last_message_timestamp': message
    });
  }

  Stream<List<GroupChat>?> streamGroupChatChanges(List<HouseProfileModel> likedHouses) {
  String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
  return FirebaseFirestore.instance.collection('group_chats')
  .where('participants', arrayContains: currentUserID)
  .snapshots(includeMetadataChanges: true)
  .map((querySnapShot) => querySnapShot.docs.map((groupChatDoc) => GroupChat(
    id: groupChatDoc.id,
    groupID: groupChatDoc.id,
    groupImage: likedHouses.firstWhere((house) => house.houseRef == groupChatDoc['house_id']).imageURLS[0],
    participantsIDs: groupChatDoc['participants'],
    lastMessageTime: groupChatDoc['last_message_timestamp'].toDate(),
    lastMessage: groupChatDoc['last_message'],
    )).toList());
  }

}