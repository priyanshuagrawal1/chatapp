import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_bubbles.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const CircularProgressIndicator();
    }
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('sentAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Text('No data');
          }
          var chatDocs = snapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                return ChatBubbles(
                  chatDocs[index].get('text'),
                  chatDocs[index].get('userId') == user.uid,
                  chatDocs[index].get('sentAt'),
                  chatDocs[index].get('imageUrl'),
                  chatDocs[index].get('userName'),
                  key: ValueKey(chatDocs[index].id),
                );
              });
        });
  }
}
