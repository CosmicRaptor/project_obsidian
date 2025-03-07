import 'dart:io';
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
  int _selectedIndex = 0; // Track selected chat

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(getUserProvider);
    final discoveryModel = ref.watch(discoveryModelProvider);
    final clients = discoveryModel.services;

    // Get username safely
    String username = userAsyncValue.maybeWhen(
      data: (user) => user.name ?? '',
      orElse: () => '',
    );

    // MOBILE LAYOUT
    if (Platform.isAndroid || Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: Text(username)),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(child: Text('Chats', style: Theme.of(context).textTheme.headlineLarge)),
              Expanded(
                child: clients.isEmpty
                    ? const Center(child: Text('No services found'))
                    : ListView.builder(
                  itemCount: clients.keys.length,
                  itemBuilder: (context, index) {
                    String serviceName = clients.keys.elementAt(index);
                    return ListTile(
                      title: Text(serviceName),
                      selected: _selectedIndex == index,
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        Navigator.pop(context); // Close drawer
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: clients.isEmpty
            ? const Center(child: Text('No services available'))
            : MessagesPage(), // Show chat page
      );
    }

    // DESKTOP (Linux) LAYOUT
    return Scaffold(
      body: YaruMasterDetailPage(
        length: clients.isNotEmpty ? clients.keys.length : 1,
        appBar: YaruWindowTitleBar(title: Text(username)),
        tileBuilder: (context, index, selected, availableWidth) {
          return clients.isNotEmpty
              ? ServiceList.fromMap(
            services: clients,
            emptyText: 'No services found',
            index: index,
            trailingServiceWidgetBuilder: (context, service) {
              return TextButton(
                onPressed: () {
                  discoveryModel.resolveService(service);
                },
                child: Text('Resolve'),
              );
            },
          )
              : const Center(child: CircularProgressIndicator());
        },
        pageBuilder: (context, index) {
          if (clients.isEmpty) {
            return const Center(child: Text('No services available'));
          }
          return YaruDetailPage(
            appBar: YaruTitleBar(title: Text(clients.keys.elementAt(index))),
            body: const MessagesPage(),
          );
        },
      ),
    );
  }
}
