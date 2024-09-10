import 'package:chat_app/providers/shared_prefs_providers.dart';
import 'package:chat_app/screens/home_screen/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaru/yaru.dart';

import 'models/user_model.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();
  runApp(const ProviderScope(child: MaterialApp(home: MyApp(),)));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AsyncValue<User> userAsyncValue = ref.watch(getUserProvider);
    return YaruTheme(
        builder: (context, yaru, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: yaru.theme,
            darkTheme: yaru.darkTheme,
            title: 'Chat App',
            home: userAsyncValue.when(
              data: (user) {
                if(user.id == null) {
                  ref.read(setuuidProvider);
                }
                return user.name == null ? const OnboardingScreen() : const HomeScreen();
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          );
        }
    );
  }
}