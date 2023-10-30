import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/screens/admin/admin_home_screen.dart';
import 'package:order/screens/user/home_screen.dart';
import 'package:order/screens/user/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/providers.dart';
import 'models/user.dart';

Future<void> saveUserStatus(bool loggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('loggedIn', loggedIn);
}

Future<bool> getUserStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('loggedIn') ??
      false; // Default to false if key doesn't exist.
}

Future<void> saveUserInfo(LocalUser user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userEmail', user.email);
  await prefs.setString('userUID', user.uid);
  await prefs.setString('userName', user.name);
  await prefs.setString('userProfileUrl', user.profileUrl);
  await prefs.setBool('admin', user.admin);
  await prefs.setBool('dispatcher', user.dispatcher);
}

Future<Map<String, dynamic>> getUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final String email = prefs.getString('userEmail') ?? '';
  final String uid = prefs.getString('userUID') ?? '';
  final String name = prefs.getString('userName') ?? '';
  final String profileUrl = prefs.getString('userProfileUrl') ?? '';
  final bool admin = prefs.getBool('admin') ?? false;
  final bool dispatcher = prefs.getBool('dispatcher') ?? false;
  final bool loggedIn = prefs.getBool('loggedIn') ?? false;
  return {
    'email': email,
    'uid': uid,
    'name': name,
    'profileUrl': profileUrl,
    'admin': admin,
    'dispatcher': dispatcher,
    'loggedIn': loggedIn
  };
}

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('loggedIn', false);
}

Future<void> checkUserStatus(BuildContext context, WidgetRef ref) async {
  final loggedIn = await getUserStatus();
  final user = ref.watch(currentUserProvider);
  if (loggedIn) {
    final Map userInfo = await getUserInfo();

    user.setUserName = userInfo['name'];
    user.setUserEmail = userInfo['email'];
    user.setProfileUrl = userInfo['profileUrl'];
    user.setUserUID = userInfo['uid'];
    user.setAdmin = userInfo['admin'];
    user.setDispatcher = userInfo['dispatcher'];
    user.setLoggedIn = true;
    if (user.admin) {
      if (context.mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  } else {
    if (context.mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
}
