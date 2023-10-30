import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/screens/admin/order_items/completed_order_item.dart';
import 'package:order/screens/user/home_screen.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../../user_shared_preferences.dart';
import '../dialogs/edit_profile_dialog.dart';
import '../user/login_screen.dart';

class AdminProfileScreen extends ConsumerWidget {
  AdminProfileScreen({super.key});
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final orderRef = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: kAppBarIconThemeData,
        titleTextStyle: kTitleTextStyle,
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(
              Icons.restaurant_menu,
            ),
          ),
          IconButton(
            onPressed: () async {
              _auth.signOut();
              await logoutUser();
              if (context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    DialogRoute(
                        context: context,
                        builder: (context) => const EditProfileDialog()));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.orangeAccent.withOpacity(0.8),
                        width: 3.0),
                    borderRadius: BorderRadius.circular(360)),
                child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: Image(
                    height: 200,
                    width: 200,
                    image: user.getProfileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              user.name,
              style: kNameTextStyle,
            ),
            const SizedBox(height: 10.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Completed Orders',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final order = orderRef.completedOrders[index];
                  return CompletedOrderItem(order);
                },
                itemCount: orderRef.completedOrders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
