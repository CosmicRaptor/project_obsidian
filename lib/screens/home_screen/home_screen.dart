import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/screens/home_screen/messages_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaru/yaru.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    User? user = ref.read(userProvider);
    print(user);
    return Scaffold(
      body: YaruMasterDetailPage(
        length: 2,
        appBar:  YaruWindowTitleBar(
          title: Text(user?.name ?? ''),
        ),
        tileBuilder: (context, index, selected, availableWidth) {
          if (index == 0) {
            return const YaruMasterTile(
              leading: Icon(YaruIcons.ubuntu_logo),
              title: Text('Page 1'),
              subtitle: Text('Ubuntu'),
            );
          } else {
            return const YaruMasterTile(
              leading: Icon(YaruIcons.colors),
              title: Text('Page 2'),
              subtitle: Text('Yaru'),
            );
          }
        },
        pageBuilder: (context, index) {
          if (index == 0) {
            return const YaruDetailPage(
              appBar: YaruWindowTitleBar(
                title: Text('Page 1'),
              ),
              body: MessagesPage(),
            );
          } else {
            return const YaruDetailPage(
              appBar: YaruWindowTitleBar(
                title: Text('Page 2'),
              ),
              body: MessagesPage(),
            );
          }
        },
      ),
    );
  }
}
