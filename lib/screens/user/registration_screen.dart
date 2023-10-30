import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/user/home_screen.dart';
import 'package:order/screens/user/login_screen.dart';

import '../../constants.dart';
import '../../user_shared_preferences.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email = '', password = '', name = '';
  final firestore = FirebaseFirestore.instance;

  Future getInfo(String infoNeeded, String userUid) async {
    var info = await firestore.collection("users").get().then((event) {
      dynamic infoDetails;
      for (var userDocs in event.docs) {
        if (userDocs.data()['uid'] == userUid) {
          infoDetails = userDocs.data()[infoNeeded];
        }
      }
      return infoDetails;
    });
    return info;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(currentUserProvider);
    return Scaffold(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 100, bottom: 50.0),
                          child: Text(
                            'Order',
                            style: kLogoTextStyle,
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Name',
                            constraints: const BoxConstraints(maxWidth: 300.0),
                            filled: true,
                            fillColor: const Color(0XFFE6E6E6),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15.0),
                          ),
                          onChanged: (value) {
                            name = value.trim();
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            constraints: const BoxConstraints(maxWidth: 300.0),
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
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              final user = userCredentials.user;
                              if (user != null) {
                                userProvider.setUserName = name;
                                userProvider.setUserEmail = email;
                                userProvider.setUserUID = user.uid;
                                userProvider.clearCart();
                                final userRef = firestore
                                    .collection("users")
                                    .doc(userProvider.email);
                                userRef.set({
                                  'name': name,
                                  'uid': user.uid,
                                  'email': email,
                                  'profileUrl': userProvider.profileUrl,
                                  'admin': false,
                                  'dispatcher': false,
                                });
                                await saveUserStatus(true);
                                await saveUserInfo(userProvider);
                                setState(() {
                                  showSpinner = false;
                                });

                                context.mounted
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()))
                                    : null;
                              }
                            } on FirebaseAuthException {
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Register',
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
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Login instead?',
                            style: TextStyle(
                                color: Color(0xFFDE550D),
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
