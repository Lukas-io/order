import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order/constants.dart';

import '../../data/providers.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  const EditProfileDialog({super.key});

  @override
  ConsumerState<EditProfileDialog> createState() => _AddDialogState();
}

class _AddDialogState extends ConsumerState<EditProfileDialog> {
  bool hasImage = false;
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  File? imageFile;
  String name = '';
  bool hasInfo = false;
  final storageRef = FirebaseStorage.instance.ref();
  final firestore = FirebaseFirestore.instance;
  bool isSpinner = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(currentUserProvider);
    return ModalProgressHUD(
      inAsyncCall: isSpinner,
      child: Dialog(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Profile Image',
                    textAlign: TextAlign.start,
                  ),
                ),
                hasImage
                    ? Stack(children: [
                        Image(
                          image: FileImage(imageFile!),
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0.0,
                          top: 0.0,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  hasImage = false;
                                });
                              },
                              icon: const Icon(
                                Icons.close_outlined,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ])
                    : Stack(alignment: Alignment.center, children: [
                        Image(
                          image: userProvider.getProfileImage,
                          height: 200.0,
                          width: 200.0,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 5.0,
                          right: 10.0,
                          child: TextButton(
                              onPressed: () async {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 40.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                photo = await _picker.pickImage(
                                                    source: ImageSource.camera,
                                                    preferredCameraDevice:
                                                        CameraDevice.front);
                                                if (photo != null) {
                                                  imageFile = File(photo!.path);
                                                  setState(() {
                                                    hasImage = true;
                                                  });
                                                }
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              style: const ButtonStyle(),
                                              icon: const Icon(
                                                  Icons.photo_camera),
                                              iconSize: 120.0,
                                              color: Colors.grey.shade700,
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                photo = await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                                if (photo != null) {
                                                  imageFile = File(photo!.path);
                                                  setState(() {
                                                    hasImage = true;
                                                  });
                                                }
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              style: const ButtonStyle(),
                                              icon: const Icon(
                                                  Icons.photo_library),
                                              iconSize: 120.0,
                                              color: Colors.grey.shade700,
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.grey.shade700),
                                shape: const MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                ),
                              ),
                              child: const Text('Change',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0))),
                        )
                      ]),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                    onChanged: (value) {
                      name = value;
                      setState(() {
                        hasInfo = name != '';
                      });
                    },
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.edit),
                        hintText: userProvider.name,
                        constraints: const BoxConstraints(maxWidth: 250.0),
                        filled: true,
                        labelStyle: const TextStyle(fontSize: 20.0),
                        fillColor: Colors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5.0))),
                const SizedBox(
                  height: 15.0,
                ),
                Opacity(
                  opacity: hasInfo || hasImage ? 1.0 : 0.5,
                  child: TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (hasInfo || hasImage) {
                        setState(() {
                          isSpinner = true;
                        });
                        if (hasImage) {
                          final profileRef = storageRef
                              .child('Profile Images/${userProvider.email}');
                          await profileRef.delete();
                          await profileRef.putFile(imageFile!);
                          userProvider.setProfileUrl =
                              await profileRef.getDownloadURL();
                          await firestore
                              .collection('users')
                              .doc(userProvider.email)
                              .update({'profileUrl': userProvider.profileUrl});
                        }
                        if (hasInfo) {
                          userProvider.setUserName = name;
                          await firestore
                              .collection('users')
                              .doc(userProvider.email)
                              .update({'name': userProvider.name});
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                        setState(() {
                          isSpinner = false;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
