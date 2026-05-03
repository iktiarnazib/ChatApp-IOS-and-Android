import 'package:chatapps/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    final String currentUserId = _auth.currentUser!.uid;

    return _firestore.collection("Users").snapshots().asyncMap((
      snapshot,
    ) async {
      // fetch ALL chatrooms at the same time instead of one by one
      // Example: fetches alice, bob, carl chatrooms simultaneously
      final futures = snapshot.docs.map((doc) async {
        final user = doc.data();
        final otherUserID = user['uid'];

        if (otherUserID == currentUserId) return null; // skip yourself

        List<String> ids = [currentUserId, otherUserID];
        ids.sort();
        String chatRoomID = ids.join('_');

        final chatRoomDoc = await _firestore
            .collection("Chat_rooms")
            .doc(chatRoomID)
            .get();

        if (chatRoomDoc.exists) {
          final chatData = chatRoomDoc.data()!;
          user['lastMessage'] = chatData['lastMessage'] ?? '';
          user['lastMessageTime'] = chatData['lastMessageTime'];
          user['unreadCount'] = chatData['unreadCount_$currentUserId'] ?? 0;
        } else {
          user['lastMessage'] = '';
          user['lastMessageTime'] = null;
          user['unreadCount'] = 0;
        }

        return user;
      }).toList();

      // wait for ALL futures to finish at the same time
      // instead of waiting one by one
      final results = await Future.wait(futures);

      // remove nulls (skipped current user)
      List<Map<String, dynamic>> usersWithChat = results
          .whereType<Map<String, dynamic>>()
          .toList();

      usersWithChat.sort((a, b) {
        final aTime = a['lastMessageTime'] as Timestamp?;
        final bTime = b['lastMessageTime'] as Timestamp?;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return usersWithChat;
    });
  }

  //send messages
  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    final chatRoomRef = _firestore.collection("Chat_rooms").doc(chatRoomID);

    // add message to subcollection
    await chatRoomRef.collection("messages").add(newMessage.toMap());

    // update chatroom document with last message info
    await chatRoomRef.set({
      "lastMessage": message,
      "lastMessageTime": timestamp,
      "lastMessageSenderID": currentUserId,
      "unreadCount_$receiverID": FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatroom id fo rtwo users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("Chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> markAsRead(String otherUserID) async {
    final String currentUserId = _auth.currentUser!.uid;

    List<String> ids = [currentUserId, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore.collection("Chat_rooms").doc(chatRoomID).update({
      "unreadCount_$currentUserId": 0,
    });
  }
}
