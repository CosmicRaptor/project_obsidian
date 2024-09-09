import 'package:chat_app/providers/user_provider.dart';
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
    User user = ref.watch(userProvider);
    return YaruTheme(
      builder: (context, yaru, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          title: 'Chat App',
          home: user.name == null ? const OnboardingScreen() : const HomeScreen(),
        );
      }
    );
  }
}

