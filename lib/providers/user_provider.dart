//a riverpod provider for the user model

import 'package:chat_app/models/user_model.dart';
import 'package:riverpod/riverpod.dart';

class UserProviderNotifier extends StateNotifier<User> {
  UserProviderNotifier() : super(User());

  void setUser(User user) {
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserProviderNotifier, User>((ref) {
  return UserProviderNotifier();
});