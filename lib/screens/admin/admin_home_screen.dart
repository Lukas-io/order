import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/data/providers.dart';
import 'package:order/screens/admin/admin_profile_screen.dart';
import 'package:order/screens/admin/delivered_tab.dart';
import 'package:order/screens/admin/pending_tab.dart';

import '../../constants.dart';
import 'menu_edit_screen.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final order = ref.watch(orderProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          iconTheme: kAppBarIconThemeData,
          titleTextStyle: kTitleTextStyle,
          // backgroundColor: const Color(0xFFFAF3F0),
          title: const Text('Order'),
          centerTitle: true,
          backgroundColor: kBackgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminProfileScreen()));
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuEditScreen()));
              },
              icon: const Icon(
                Icons.edit,
              ),
            )
          ],
          bottom: TabBar(
            labelColor: kPrimaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: kPrimaryColor,
            unselectedLabelColor: const Color(0XFFDE550D).withOpacity(0.6),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
            tabs: [
              Tab(
                text: 'Pending${order.itemsCount(order.pendingOrders)}',
              ),
              Tab(
                text: 'Delivering${order.itemsCount(order.deliveredOrders)}',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const PendingTab(),
            DeliverTab(),
          ],
        ),
      ),
    );
  }
}
