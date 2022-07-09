class Message {
  final String message;
  final String otherUserID;
  final bool sentByCurrent;
  final DateTime timeStamp;

  Message({
    required this.message,
    required this.otherUserID,
    required this.sentByCurrent,
    required this.timeStamp
  });
}
