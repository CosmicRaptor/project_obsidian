import 'package:chat_app/providers/connection_provider.dart';
import 'package:chat_app/providers/shared_prefs_providers.dart';
import 'package:chat_app/screens/home_screen/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesPage extends ConsumerWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    final messages = ref.watch(messagesProvider);
    final userAsyncVal = ref.watch(getUserProvider);
    return Column(
      children: [
        SizedBox(
          height: height * 0.9,
          child: ListView.builder(
            itemCount: messages.length,
              itemBuilder: (context, index) {
            final message = messages[index];
            final isSender = userAsyncVal.maybeWhen(
                data: (user) => user.id == message.uuid,
                orElse: () => false,
                );
            return Row(
              mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                MessageCard(
                  msg: message.message,
                  isSender: userAsyncVal.maybeWhen(
                    data: (user) => user.id == message.uuid,
                    orElse: () => false,
                  ),
                ),
              ],
            );
          }),
        ),
        // const Divider(),
        //send message box
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter your message',
                ),
                onSubmitted: (value) {
                String uuid = '';
                userAsyncVal.when(
                  data: (user) => uuid = user.id ?? '',
                  loading: () {},
                  error: (error, stack) {},
                );
                // final msg = Message(uuid: uuid, message: value);
          
                  ref.read(tcpConnectionProvider.notifier).sendMessage(value, uuid);
                  controller.clear();
                },
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),

      ],
    );
  }
}
