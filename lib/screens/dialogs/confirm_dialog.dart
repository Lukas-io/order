import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order/screens/dialogs/status_dialog.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../../models/food.dart';

class ConfirmDialog extends ConsumerStatefulWidget {
  const ConfirmDialog({super.key});

  @override
  ConsumerState<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends ConsumerState<ConfirmDialog> {
  final firestore = FirebaseFirestore.instance;
  bool isSpinner = false;

  Future<int> getDocumentCount(String collection) async {
    final firestoreInstance = FirebaseFirestore.instance;
    final collectionReference = firestoreInstance.collection(collection);
    final QuerySnapshot querySnapshot = await collectionReference.get();

    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return ModalProgressHUD(
      inAsyncCall: isSpinner,
      child: Dialog(
          child: Container(
        height: 400.0,
        padding: const EdgeInsets.all(20.0),
        decoration: ShapeDecoration(
            color: kBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
        child: Column(
          children: [
            const Opacity(
              opacity: 0.7,
              child: Text('Order',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (user.cartOrders.length == index) {
                    return Column(
                      children: [
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "N${user.getTotalAmount.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Color(0xFF19C32A),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    final Food food = user.cartOrders[index];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${food.name} x${food.quantity}',
                            style: const TextStyle(fontSize: 24)),
                        Text(
                          'N${(food.price * food.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 24),
                        )
                      ],
                    );
                  }
                },
                itemCount: user.cartOrders.length + 1,
              ),
            ),
            TextButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  isSpinner = true;
                });

                int orderId = await getDocumentCount('orders');
                List<Map> orders = [];
                for (Food order in user.cartOrders) {
                  orders.add(<String, dynamic>{
                    'food': order.name,
                    'quantity': order.quantity,
                    'price': order.price
                  });
                }
                await firestore
                    .collection('orders')
                    .doc(orderId.toString())
                    .set(<String, dynamic>{
                  'id': orderId,
                  'order': orders,
                  'uid': user.uid,
                  'status': 'pending',
                  'total': user.getTotalAmount,
                });
                setState(() {
                  isSpinner = false;
                });

                context.mounted
                    ? Navigator.pushReplacement(
                        context,
                        DialogRoute(
                            context: context,
                            builder: (context) => const StatusDialog()))
                    : null;
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white, fontSize: 29.0),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
