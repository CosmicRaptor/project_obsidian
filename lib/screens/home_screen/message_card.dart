import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class MessageCard extends StatelessWidget {
  final Message msg;
  const MessageCard({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return YaruBorderContainer(
      padding: const EdgeInsets.all(8),
      color: msg.isSender ? Theme.of(context).primaryColor : Colors.grey[600],
      child: Text(
        msg.text
      ),
    );
  }
}
