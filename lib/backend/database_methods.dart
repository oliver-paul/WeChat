import 'package:cloud_firestore/cloud_firestore.dart';

class Database_Methods 
{
  getUsername(String User_name) async {
    return await FirebaseFirestore.instance
        .collection("Accounts")
        .where("Username", isEqualTo: User_name)
        .get();
  }

  getEmail(String User_name) async {
    return await FirebaseFirestore.instance
        .collection("Accounts")
        .where("Email", isEqualTo: User_name)
        .get();
  }

  uploadData(userMap) {
    FirebaseFirestore.instance.collection("Accounts").add(userMap);
  }

  createChatRoom(String charRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(charRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  send_messages(String chatroom_id, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroom_id)
        .collection("chats")
        .add(messageMap)
        .catchError((Object error) {
      print("Error in sending the messages");
    });
  }

  get_messages(String chatroom_id) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroom_id)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getallusers(String username) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
