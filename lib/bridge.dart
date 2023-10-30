import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/constants.dart';
import 'package:order/user_shared_preferences.dart';

class Bridge extends ConsumerStatefulWidget {
  const Bridge({super.key});

  @override
  ConsumerState<Bridge> createState() => _BridgeState();
}

class _BridgeState extends ConsumerState<Bridge> {
  @override
  void initState() {
    // TODO: implement initState

    checkUserStatus(context, ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              image: AssetImage('images/Order.png'),
            ),
          )
        ],
      ),
    );
  }
}
