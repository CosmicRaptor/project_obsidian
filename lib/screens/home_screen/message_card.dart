import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class MessageCard extends StatelessWidget {
  final String msg;
  final bool isSender;
  const MessageCard({super.key, required this.msg, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return YaruBorderContainer(
      padding: const EdgeInsets.all(8),
      color: isSender ? Theme.of(context).primaryColor : Colors.grey[600],
      child: Text(
        msg
      ),
    );
  }
}
