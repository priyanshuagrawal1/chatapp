import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(
      this.message, this.isMe, this.time, this.imgUrl, this.username,
      {Key? key})
      : super(key: key);
  final String message;
  final bool isMe;
  final String username;
  final String imgUrl;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    Image profilePic = Image.network(imgUrl);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 180,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        fontSize: 16,
                        color: isMe ? Colors.black : Colors.white,
                        overflow: TextOverflow.clip),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 0,
                right: isMe ? 5 : 0,
                child: CircleAvatar(
                  backgroundImage: profilePic.image,
                ))
          ],
        ),
      ],
    );
  }
}
