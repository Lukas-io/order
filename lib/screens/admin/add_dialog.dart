import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order/constants.dart';

import '../../data/providers.dart';
import '../../models/food.dart';

class AddDialog extends ConsumerStatefulWidget {
  const AddDialog({super.key});

  @override
  ConsumerState<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends ConsumerState<AddDialog> {
  bool hasImage = false;
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  File? imageFile;
  String foodName = '', price = '';
  bool hasInfo = false;
  final storageRef = FirebaseStorage.instance.ref();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Dialog(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: Colors.transparent,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Food Image',
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
                    : IconButton(
                        onPressed: () async {
                          photo = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (photo != null) {
                            imageFile = File(photo!.path);
                            setState(() {
                              hasImage = true;
                            });
                          }
                        },
                        style: const ButtonStyle(),
                        icon: const Icon(Icons.photo_library),
                        iconSize: 150.0,
                        color: Colors.grey.shade700,
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                    onChanged: (value) {
                      foodName = value.trim();
                      setState(() {
                        hasInfo = price != '' && foodName != '';
                      });
                    },
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        hintText: 'Food',
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
                  height: 10.0,
                ),
                TextField(
                    onChanged: (value) {
                      price = value.trim();
                      setState(() {
                        hasInfo = price != '' && foodName != '';
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Price',
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
                  opacity: hasInfo && hasImage ? 1.0 : 0.5,
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
                      if (hasImage && hasInfo) {
                        setState(() {
                          isLoading = true;
                        });
                        final foodRef =
                            storageRef.child('Food Images/$foodName');
                        await foodRef.putFile(imageFile!);
                        Food food = Food(
                          imageUrl: await foodRef.getDownloadURL(),
                          name: foodName,
                          price: double.parse(price),
                        );
                        await menu.addFood(food);

                        setState(() {
                          isLoading = true;
                        });
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
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
