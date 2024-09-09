import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/home_screen/message_card.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MessageCard(msg: Message(isSender: false, text: 'Hello Ubuntu', isLiked: false, sender: 'Ubuntu', time: DateTime.now())),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MessageCard(msg: Message(isSender: true, text: 'Hello Yaru', isLiked: false, sender: 'Yaru', time: DateTime.now())),
          ],
        ),
      ],
    );
  }
}
