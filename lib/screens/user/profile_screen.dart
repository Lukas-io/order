import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/screens/user/app_drawer.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../dialogs/edit_profile_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        iconTheme: kAppBarIconThemeData,
        titleTextStyle: kTitleTextStyle,
        title: const Text('Profile'),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        color: kBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40.0,
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
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Orders',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '5',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Spent',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'N12678',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
