import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constants.dart';
import '../../data/providers.dart';
import '../../models/food.dart';
import '../dialogs/status_dialog.dart';

class DispatcherScreen extends ConsumerStatefulWidget {
  const DispatcherScreen({super.key});

  @override
  ConsumerState<DispatcherScreen> createState() => _DispatcherScreenState();
}

class _DispatcherScreenState extends ConsumerState<DispatcherScreen> {
  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final user = ref.watch(currentUserProvider);

    Future<int> getDocumentCount(String collection) async {
      final firestoreInstance = FirebaseFirestore.instance;
      final collectionReference = firestoreInstance.collection(collection);
      final QuerySnapshot querySnapshot = await collectionReference.get();

      return querySnapshot.size;
    }

    bool isLoading = false;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Dispatcher'),
        titleTextStyle: kTitleTextStyle,
        centerTitle: true,
        backgroundColor: kBackgroundColor,
        iconTheme: kAppBarIconThemeData,
        // leading: IconButton(onPressed: (Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home))),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          color: kBackgroundColor,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Select One',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  user.toggle();
                },
                child: Container(
                  width: double.infinity,
                  foregroundDecoration: user.toggleSwitch
                      ? const BoxDecoration()
                      : BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                        ),
                  padding: const EdgeInsets.all(10.0),
                  decoration: ShapeDecoration(
                    color: kBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 6.0,
                        offset: Offset(1.5, 4.0),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const ShapeDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/dispatcher.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: OvalBorder(),
                                ),
                              ),
                              // const SizedBox(height: 16),
                              // const Text(
                              //   'Available',
                              //   style: TextStyle(
                              //     color: Color(0xFF19C32A),
                              //     fontSize: 24,
                              //     fontFamily: 'Roboto Slab',
                              //     fontWeight: FontWeight.w400,
                              //     height: 0.04,
                              //     letterSpacing: 0.24,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ademola Adeyinka',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Investment One',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 16),
                      // Text(
                      //   'Opay - 8086198843',
                      //   style: TextStyle(
                      //     color: Colors.black.withOpacity(0.5),
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Opacity(
        opacity: user.toggleSwitch ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            if (!user.toggleSwitch) {
              int orderId = await getDocumentCount('orders');
              List<Map> orders = [];
              for (Food order in user.cartOrders) {
                orders.add(<String, dynamic>{
                  'food': order.name,
                  'quantity': order.quantity,
                });
              }
              await firestore
                  .collection('orders')
                  .doc(orderId.toString())
                  .set(<String, dynamic>{
                'id': orderId,
                'order': orders,
                'uid': user.uid,
                'status': 'uncompleted'
              });
              setState(() {
                isLoading = false;
              });
              user.clearCart();
              if (context.mounted) {
                Navigator.push(
                    context,
                    DialogRoute(
                        context: context,
                        builder: (context) => const StatusDialog()));
              }
            }
          },
          child: Container(
            width: double.infinity,
            height: 86,
            margin: const EdgeInsets.all(20.0),
            decoration: ShapeDecoration(
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'FINISH',
                style: kBottomSheetTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
