import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/message.dart';

class MessagesAPI {

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

  Stream<List<Message>?> listenToPrivateChat(String? currentUserID, String? otherUserID) async* {
    try {
      List<Message>? messages = await getPrivateMessages(currentUserID, otherUserID);
      while(true){
        await Future.delayed(const Duration(seconds: 2));
        List<Message>? newMessages = await getPrivateMessages(currentUserID, otherUserID);
        if(newMessages!.length > messages!.length){
          messages = newMessages;
          yield newMessages;
        } 
      }
    } catch (e) {
      debugPrint("Error - $e");
    }
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
}