import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //instance of firestore (pup add cloud_firestore)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //sending messages
  Future<void> sendMessage(String recieverId, String message) async {
    // get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      recieverId: recieverId,
      message: message,
      timestamp: timestamp,
    );

    // create a chat room with a unique id
    List<String> ids = [currentUserId, recieverId];
    ids.sort();

    String chatRoomId = ids.join("-");

    // add message to database
    await _firestore
        .collection("ChatRooms")
        .doc(chatRoomId)
        .collection("Messages")
        .add(newMessage.toMap());
  }

  //recieving messages
  Stream<QuerySnapshot> getMessageStream(String userId, otherId) {
    List<String> ids = [userId, otherId];
    ids.sort();
    String chatRoomId = ids.join("-");

    return _firestore
        .collection("ChatRooms")
        .doc(chatRoomId)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
