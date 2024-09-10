import 'package:chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//providers to store and retrieve username entered by user

//provider for shared prefs instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

//provider to set the username passed
final setUsernameProvider = FutureProvider.family<String, String>((ref, username) async {
  SharedPreferences prefs = await ref.read(sharedPreferencesProvider.future);
  prefs.setString('username', username);
  print(prefs.getString('username'));
  return username;
});

//provider to get the username stored
final getUserNameProvider = FutureProvider<User>((ref) async {
  SharedPreferences prefs = await ref.read(sharedPreferencesProvider.future);
  String? username = prefs.getString('username');
  return User(name: username);
});