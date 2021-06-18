import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/backend/database_methods.dart';
import 'package:we_chat/classes/constant%20_names.dart';
import 'package:we_chat/screens/chat_page.dart';
import 'package:we_chat/screens/conversation.dart';

class searching_page extends StatefulWidget {
  searching_page({Key key}) : super(key: key);

  @override
  _searching_pageState createState() => _searching_pageState();
}

class _searching_pageState extends State<searching_page> {
  TextEditingController search_name = TextEditingController();

  Database_Methods m = new Database_Methods();

  QuerySnapshot search_snapshot;

  initiate_state() {
    m.getUsername(search_name.text).then((val) {
      print("Value Recived !!  $val");
      setState(() {
        search_snapshot = val;
      });
    });
  }

  Widget searching_list() 
  {
    return search_snapshot != null
        ? ListView.builder(
            itemCount: search_snapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  u_name: search_snapshot.docs[index].get("Username"),
                  email: search_snapshot.docs[index].get("Email"));
            })
        : Center(
            child: Container(
            child: Text("Enter any valid Username.."),
          ));
  }

  create_conversation_room(String u_name) {
    if (u_name != constant_files.current_username) {
      String chatRoomId =
          getChatRoomId(u_name, constant_files.current_username);
      List<String> users = [u_name, constant_files.current_username];
      Map<String, dynamic> charRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      m.createChatRoom(chatRoomId, charRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => conversation(chat_room_id: chatRoomId)));
    } else {
      print("You cant send message to your self");
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(5.0, 35.0, 5.0, 0.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.green[100],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: search_name,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search username",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          initiate_state();
                        })
                  ],
                ),
              ),
              searching_list(),
            ],
          ),
        ),
      ),
    );
  }

  Widget SearchTile({String u_name, String email}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 70.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Username:  " + u_name),
              SizedBox(
                height: 8.0,
              ),
              Text("Email:  " + email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              create_conversation_room(u_name);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}

// create_conversation_room({String u_name}) {
//   String chatRoomId = getChatRoomId(u_name, constant_files.current_username);
//   List<String> users = [u_name, constant_files.current_username];
//   Map<String, dynamic> charRoomMap = {"users": users, "chatroomId": chatRoomId};
//   Database_Methods().createChatRoom(chatRoomId, charRoomMap);
//   Navigator.push(
//         context, MaterialPageRoute(builder: (context) => conversation()));
// }

// class search_row extends StatelessWidget {
//   String u_name;
//   String email;

//   search_row({this.u_name, this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
//       child: Row(
//         children: <Widget>[
//           SizedBox(
//             height: 70.0,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text("Username:  " + u_name),
//               SizedBox(
//                 height: 8.0,
//               ),
//               Text("Email:  " + email),
//             ],
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               create_conversation_room(u_name: u_name);
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.greenAccent,
//                   borderRadius: BorderRadius.circular(10.0)),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Text(
//                 "Message",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
