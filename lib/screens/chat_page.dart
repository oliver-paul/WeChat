import 'package:flutter/material.dart';
import 'package:we_chat/Widgets/widget.dart';
import 'package:we_chat/backend/database_methods.dart';
import 'package:we_chat/classes/constant%20_names.dart';
import 'package:we_chat/classes/shared_preference_methods.dart';
import 'package:we_chat/screens/Drawer.dart';
import 'package:we_chat/screens/conversation.dart';
import 'package:we_chat/screens/search.dart';

class chat_page extends StatefulWidget {
  @override
  _chat_pageState createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  Database_Methods m = new Database_Methods();
  Stream chatRoomStream;

  Widget chatRoomlist() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return userTile(
                        user_name: snapshot.data.docs[index]
                            .data()["chatroomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(constant_files.current_username, ""),
                        chat_room_id:
                            snapshot.data.docs[index].data()["chatroomId"]);
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserinfo();
    super.initState();
  }

  getUserinfo() async {
    constant_files.current_username =
        await shared_preferenec_methods.getUserNameSharedPreference();
    m.getallusers(constant_files.current_username).then((v) {
      setState(() {
        chatRoomStream = v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: main_app_bar(BuildContext),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => searching_page()));
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.search),
      ),
      drawer: Drawer(
        child: drawer(),
      ),
      body: chatRoomlist(),
    );
  }
}

class userTile extends StatelessWidget {
  String user_name;
  String chat_room_id;

  userTile({this.user_name, this.chat_room_id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    conversation(chat_room_id: chat_room_id)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                user_name.substring(0, 1).toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              user_name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 30.0,
              thickness: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
