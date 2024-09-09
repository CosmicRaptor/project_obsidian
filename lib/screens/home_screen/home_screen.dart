import 'package:yaru/yaru.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Home Screen', style: TextStyle(color: Theme.of(context).primaryColor),),
      ),
    );
  }
}
