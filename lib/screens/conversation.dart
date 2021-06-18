import 'package:flutter/material.dart';
import 'package:we_chat/backend/database_methods.dart';
import 'package:we_chat/classes/constant%20_names.dart';

class conversation extends StatefulWidget {
  String chat_room_id;

  conversation({this.chat_room_id});

  @override
  _conversationState createState() => _conversationState();
}

class _conversationState extends State<conversation> {
  Database_Methods m = new Database_Methods();
  TextEditingController get_message_controller = new TextEditingController();
  var chatMessageStream;

  Widget chat_list() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return messageTile(
                      message: snapshot.data.docs[index].data()["message"],
                      sendByMe: snapshot.data.docs[index].data()["user"] ==
                          constant_files.current_username,
                      t: snapshot.data.docs[index].data()["time"],
                      u: snapshot.data.docs[index]
                          .data()["user"]
                          .toString()
                          .toUpperCase(),
                    );
                  })
              : Container();
        });
  }

  sendMessaage() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        " ${now.hour.toString()}:${now.minute.toString()} ${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    if (get_message_controller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": get_message_controller.text,
        "user": constant_files.current_username,
        "time": convertedDateTime
      };

      m.send_messages(widget.chat_room_id, messageMap);

      setState(() {
        get_message_controller.text = "";
      });
    }
  }

  @override
  void initState() {
    m.get_messages(widget.chat_room_id).then((value) {
      setState(() {
        chatMessageStream = value;
        print(value.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    String ChatPageName = widget.chat_room_id
        .replaceAll('_', "")
        .replaceAll(constant_files.current_username, "")
        .toUpperCase()
        .toString();

    //double hei= MediaQuery.of(context).size.width ;
    return Scaffold(
      appBar: AppBar(
        title: Text(ChatPageName),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          //Conversation tile place
          Expanded(
            child: Container(child: chat_list()),
          ),

          //The message Entering and sendng tile
          Container(
            padding: EdgeInsets.all(5.0),
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: get_message_controller,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      
                      hintText: "Enter the message......",
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      sendMessaage();
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class messageTile extends StatelessWidget {
  final String message;
  final sendByMe;
  final u;
  final t;

  messageTile({this.message, this.sendByMe, this.t, this.u});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 14, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: sendByMe ? Colors.blue[700] : Colors.black),
        child: sendByMe
            ? Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text( u,
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(t,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                ],
              )
            : Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(u,
                        style: TextStyle(
                            color: Colors.brown[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(t,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                ],
              ),
      ),
    );
  }
}
