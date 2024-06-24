import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order/models/menu.dart';
import 'package:order/models/order.dart';

import '../models/user.dart';

final currentUserProvider = ChangeNotifierProvider<LocalUser>((ref) {
  return LocalUser(cartOrders: [], orders: []);
});

final container = ProviderContainer();

final menuProvider = ChangeNotifierProvider((ref) => Menu());

final orderProvider = ChangeNotifierProvider((ref) => Order());
