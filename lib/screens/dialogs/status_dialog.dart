import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';

class StatusDialog extends ConsumerWidget {
  const StatusDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return WillPopScope(
      onWillPop: () async {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
        user.clearCart();

        return true;
      },
      child: const Dialog(
        surfaceTintColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFF19C42A),
              grade: 0.2,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Success',
                style: TextStyle(
                  color: Color(0xFF19C42A),
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: TextButton(
            //     style: const ButtonStyle(
            //       backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
            //       shape: MaterialStatePropertyAll(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(15.0)),
            //         ),
            //       ),
            //     ),
            //     onPressed: () {
            //
            //       // Navigator.push(
            //       //     context,
            //       //     MaterialPageRoute(
            //       //         builder: (context) => const OrderScreen()));
            //     },
            //     child: const Text(
            //       'Check Order',
            //       style: TextStyle(color: Colors.white, fontSize: 29.0),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
