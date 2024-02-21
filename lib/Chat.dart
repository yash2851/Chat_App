import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String email;
  final String authEmail;

  const ChatScreen({Key? key, required this.email, required this.authEmail})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('abc@yopmail.com'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs;
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Align(
                        alignment: (index % 2 == 0)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          child: Text(data[index]['message']),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 65,
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(hintText: "Enter Message"),
              ),
            ),
            IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('Chat')
                      .doc("${widget.authEmail}-${widget.email}")
                      .collection('chats')
                      .doc()
                      .set({
                    'message': messageController.text,
                    'sendBy': widget.authEmail,
                    'creatBy': DateTime.now().toString()
                  });
                },
                icon: Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
