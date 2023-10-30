import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order/constants.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/user/home_screen.dart';
import 'package:order/screens/user/login_screen.dart';
import 'package:order/screens/user/profile_screen.dart';

import '../../user_shared_preferences.dart';
import 'order_screen.dart';

class AppDrawer extends ConsumerWidget {
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance;
    final userRef = ref.watch(currentUserProvider);
    return Drawer(
      child: Material(
        color: kBackgroundColor,
        child: Container(
          margin: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                        image: userRef.getProfileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    userRef.name,
                    textAlign: TextAlign.center,
                    style: kNameTextStyle,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Home',
                            style: kHeadingTextStyle,
                          ),
                        ),
                        const Divider(
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Profile',
                            style: kHeadingTextStyle,
                          ),
                        ),
                        const Divider(
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrderScreen()));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Order',
                            style: kHeadingTextStyle,
                          ),
                        ),
                        const Divider(
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // GestureDetector(
                  //   child: Container(
                  //     width: 230,
                  //     height: 55,
                  //     margin: const EdgeInsets.all(5.0),
                  //     decoration: ShapeDecoration(
                  //       color: kBackgroundColor,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //       shadows: const [
                  //         BoxShadow(
                  //           color: Color(0x3F000000),
                  //           blurRadius: 4,
                  //           offset: Offset(2, 4),
                  //         )
                  //       ],
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const Icon(
                  //           Icons.dark_mode,
                  //           size: 30.0,
                  //         ),
                  //         Text(
                  //           'Dark Mode',
                  //           style: GoogleFonts.robotoSlab(
                  //               fontSize: 28.0, fontWeight: FontWeight.w500),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () async {
                      await logoutUser();
                      await auth.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }
                    },
                    child: Container(
                      width: 230,
                      margin: const EdgeInsets.all(5.0),
                      height: 55,
                      decoration: ShapeDecoration(
                        color: kBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(2, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            size: 30.0,
                            color: kPrimaryColor,
                          ),
                          Text(
                            'Log Out',
                            style: GoogleFonts.robotoSlab(
                              color: kPrimaryColor,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
