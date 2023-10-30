import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/user/registration_screen.dart';

import '../../constants.dart';
import '../../user_shared_preferences.dart';
import '../admin/admin_home_screen.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool showSpinner = false;
  bool authFailed = false;
  final _auth = FirebaseAuth.instance;
  String email = '', password = '';
  final firestore = FirebaseFirestore.instance;

  // Future getInfo(String infoNeeded, String email) async {
  //   var info = await firestore.collection("users").get().then((event) {
  //     dynamic infoDetails;
  //     for (var userDocs in event.docs) {
  //       if (userDocs.data()['uid'] == userUid) {
  //         infoDetails = userDocs.data()[infoNeeded];
  //       }
  //     }
  //     return infoDetails;
  //   });
  //   return info;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(currentUserProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height - 30,
            ),
            child: IntrinsicHeight(
              child: ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(top: 100, bottom: 50.0),
                            child: Text(
                              'Order',
                              style: kLogoTextStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                              constraints:
                                  const BoxConstraints(maxWidth: 300.0),
                              filled: true,
                              fillColor: const Color(0XFFE6E6E6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15.0),
                            ),
                            onChanged: (value) {
                              email = value.toLowerCase().trim();
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                constraints:
                                    const BoxConstraints(maxWidth: 300.0),
                                filled: true,
                                fillColor: const Color(0XFFE6E6E6),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15.0)),
                            onChanged: (value) {
                              password = value;
                            },
                          ),
                          authFailed
                              ? Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: const Text(
                                    'Invalid email or password. Try again!',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 30.0),
                          TextButton(
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(kPrimaryColor),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final userCredentials =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                final user = userCredentials.user;
                                if (user != null && context.mounted) {
                                  final userInfo =
                                      firestore.collection('users').doc(email);
                                  final userDocs = await userInfo.get().then(
                                      (DocumentSnapshot documentSnapshot) {
                                    if (documentSnapshot.exists) {
                                      Map<String, dynamic> data =
                                          documentSnapshot.data()
                                              as Map<String, dynamic>;
                                      return data;
                                    }
                                  });
                                  userProvider.setUserName = userDocs?['name'];
                                  userProvider.setUserEmail =
                                      userDocs?['email'];
                                  userProvider.setUserUID = user.uid;
                                  userProvider.setAdmin = userDocs?['admin'];
                                  userProvider.setDispatcher =
                                      userDocs?['dispatcher'];
                                  userProvider.setProfileUrl =
                                      userDocs?['profileUrl'];
                                  userProvider.clearCart();
                                  await saveUserStatus(true);
                                  print('SAVED PROPERLY11111111111');
                                  await saveUserInfo(userProvider);
                                  print(
                                      'SAVED PROPERLY11111111111222222222222');

                                  setState(() {
                                    authFailed = false;
                                    showSpinner = false;
                                  });

                                  if (userProvider.admin) {
                                    context.mounted
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AdminHomeScreen()))
                                        : null;
                                  } else {
                                    context.mounted
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()))
                                        : null;
                                  }
                                }
                              } on FirebaseAuthException {
                                setState(() {
                                  showSpinner = false;
                                  authFailed = true;
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()));
                        },
                        child: const Text('Create an account',
                            style: TextStyle(
                                color: Color(0xFFDE550D),
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
