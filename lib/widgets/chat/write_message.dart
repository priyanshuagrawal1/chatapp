import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class WriteMessage extends StatefulWidget {
  const WriteMessage({Key? key}) : super(key: key);

  @override
  _WriteMessageState createState() => _WriteMessageState();
}

class _WriteMessageState extends State<WriteMessage> {
  final _textController = TextEditingController();
  String? _enteredMessage;

  Future<void> _sendText(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (user == null) {
      return;
    }
    FirebaseFirestore.instance.collection('chats').add({
      'text': text,
      'sentAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData['username'],
      'imageUrl': userData['imgUrl']
    });
    _textController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: (_enteredMessage == null)
                ? null
                : () => _sendText(_enteredMessage!),
          )
        ],
      ),
    );
  }
}
