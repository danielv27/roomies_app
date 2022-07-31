import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:roomies_app/models/message.dart';

class MessagesAPI {

  Future uploadMessage(String message, String? fromID, String? toID) async {
    final fromRef = FirebaseFirestore.instance.collection('users/$fromID/messages');
    final toRef = FirebaseFirestore.instance.collection('users/$toID/messages');
    try{
      await fromRef.add({
        'message': message,
        'otherUserID': toID,
        'sentByCurrent': true,
        'timeStamp': DateTime.now()
      });

      await toRef.add({
        'message': message,
        'otherUserID': fromID,
        'sentByCurrent': false,
        'timeStamp': DateTime.now()
      });
      print('message sent to firebase\n');
    } catch (e) {
      debugPrint("Error - $e");
      return null;
    }

  }

  Future<List<Message>?> getMessages(String? currentUserID, String? otherUserID) async {
    try {
      List<Message>? messages = [];
      await FirebaseFirestore.instance.collection('users/$currentUserID/messages')
      .where('otherUserID', isEqualTo: otherUserID)
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

  Stream<List<Message>?> listenToMessages(String? currentUserID, String? otherUserID) async* {
    try {
      List<Message>? messages = await getMessages(currentUserID, otherUserID);
      while(true){
        await Future.delayed(const Duration(seconds: 2));
        List<Message>? newMessages = await getMessages(currentUserID, otherUserID);
        if(newMessages!.length > messages!.length){
          messages = newMessages;
          yield newMessages;
        } 
      }
    } catch (e) {
      debugPrint("Error - $e");
    }
  }

}