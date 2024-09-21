import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/multicast_provider.dart';
import 'package:chat_app/providers/shared_prefs_providers.dart';
import 'package:chat_app/screens/home_screen/messages_page.dart';
import 'package:chat_app/screens/home_screen/service_list.dart';
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
    // Watch the getUserNameProvider
    AsyncValue<User> userAsyncValue = ref.watch(getUserProvider);
    userAsyncValue.when(
      data: (user) => print(user),
      loading: () => print('Loading...'),
      error: (error, stack) => print('Error: $error'),
    );

    // Watch the multicastProvider
    final discoveryModel = ref.watch(discoveryModelProvider);
    final clients = discoveryModel.services;

    return Scaffold(
      body: YaruMasterDetailPage(
        length: clients.keys.length,
        appBar: YaruWindowTitleBar(
          title: Text(userAsyncValue.maybeWhen(
            data: (user) => user.name ?? '',
            orElse: () => '',
          )),
        ),
        tileBuilder: (context, index, selected, availableWidth) {
          return ServiceList.fromMap(
              services: clients,
              emptyText: 'No services found',
              trailingServiceWidgetBuilder: (context, service) {
                return TextButton(
                  onPressed: () {
                    discoveryModel.resolveService(service);
                  },
                  child: Text('Resolve'),
                );
              }
          );
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