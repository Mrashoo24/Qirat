import 'dart:convert';

import 'package:eshop/core/constant/strings.dart';
import 'package:eshop/core/router/new_web_router.dart';
import 'package:eshop/core/theme/qirat_theme.dart';
import 'package:eshop/core/util/cartCalc.dart';
import 'package:eshop/domain/entities/order/order_details.dart';
import 'package:eshop/domain/entities/order/order_item.dart';
import 'package:eshop/presentation/blocs/cart/cart_bloc.dart';
import 'package:eshop/presentation/blocs/order/order_add/order_add_cubit.dart';
import 'package:eshop/presentation/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../domain/entities/cart/cart_item.dart';

import '../../../../core/services/services_locator.dart';

class PaymentReturnView extends StatefulWidget {
  const PaymentReturnView({super.key});

  @override
  State<PaymentReturnView> createState() => _PaymentReturnViewState();
}

class _PaymentReturnViewState extends State<PaymentReturnView> {
  @override
  void initState() {
    super.initState();
    // Kick off verification after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleReturn());
  }

  Future<void> _handleReturn() async {
    final uri = Uri.base;
    final orderId =
        uri.queryParameters['order_id'] ?? uri.queryParameters['orderId'];
    if (orderId == null || orderId.isEmpty) {
      context.go(NewWebRouter.checkoutv2);
      return;
    }

    EasyLoading.show(status: 'Verifying payment...');
    final verified = await _verifyPaymentWithServer(orderId);
    EasyLoading.dismiss();

    // Gather current user, cart and selected delivery info
    // On Web, after full redirect the app reloads; wait briefly for Auth/UserBloc
    final authReady = await _waitForAuthUser(const Duration(seconds: 5));
    var userState = context.read<UserBloc>().state;
    if (userState is! UserLogged) {
      userState =
          await _waitForUserLogged(const Duration(seconds: 5)) ?? userState;
    }
    if (userState is! UserLogged || authReady == null) {
      EasyLoading.showError('Please sign in to complete payment');
      context.go(NewWebRouter.newSignIn);
      return;
    }
    final logged = userState; // already UserLogged here

    final selected = logged.user.deliveryInfos.where((e) => e.isSelected);
    if (selected.isEmpty) {
      EasyLoading.showError('Select a delivery address');
      context.go(NewWebRouter.newProfile);
      return;
    }

    // Ensure cart is loaded from cache after app reload
    final cartBloc = context.read<CartBloc>();
    cartBloc.add(const GetCart());
    final items = await _waitForCartItems(const Duration(seconds: 5));
    if (items.isEmpty) {
      // As a fallback, go to checkout
      EasyLoading.showError('No items to place order');
      context.go(NewWebRouter.checkoutv2);
      return;
    }

    // Place order with status based on verification outcome
    final info =
        verified ? 'ONLINE:SUCCESS ($orderId)' : 'ONLINE:PENDING ($orderId)';

    final total = CartCalculator.getTotal(items);

    // Build order items and log types for debugging
    final builtOrderItems = items
        .map((i) => OrderItem(
              id: '',
              product: i.product,
              priceTag: i.priceTag,
              price: i.priceTag.price,
              quantity: i.quantity,
            ))
        .toList();
    debugPrint(
        'PaymentReturn: items count=${items.length} types=${items.map((e) => e.runtimeType).toList()}');
    debugPrint(
        'PaymentReturn: builtOrderItems types=${builtOrderItems.map((e) => e.runtimeType).toList()}');

    try {
      context.read<OrderAddCubit>().addOrder(OrderDetails(
            id: '',
            orderItems: builtOrderItems,
            deliveryInfo: selected.first,
            discount: 0,
            uid: logged.user.id,
            total: total,
            status: 'PENDING',
            info: info,
            date: DateTime.now().toString().split('.').first,
          ));
    } catch (e, st) {
      debugPrint('PaymentReturn: addOrder error: $e\n$st');
      EasyLoading.showError('Failed to place order');
      context.go(NewWebRouter.checkoutv2);
      return;
    }
  }

  Future<bool> _verifyPaymentWithServer(String orderId) async {
    final baseUrl = const String.fromEnvironment(
      'BACKEND_BASE_URL',
      defaultValue: kbaseurl,
    );
    try {
      final client = sl<http.Client>();
      final uri =
          Uri.parse('$baseUrl/payment/cashfree/verify?order_id=$orderId');
      final resp = await client.get(uri).timeout(const Duration(seconds: 20));
      if (resp.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(resp.body) as Map<String, dynamic>;
        final status = (body['order_status'] ?? body['orderStatus'] ?? '')
            .toString()
            .toUpperCase();
        return status == 'PAID';
      }
    } catch (_) {}
    return false;
  }

  Future<User?> _waitForAuthUser(Duration timeout) async {
    final auth = sl<FirebaseAuth>();
    final current = auth.currentUser;
    if (current != null) return current;
    try {
      return await auth
          .authStateChanges()
          .firstWhere((u) => u != null)
          .timeout(timeout);
    } catch (_) {
      return auth.currentUser;
    }
  }

  Future<UserLogged?> _waitForUserLogged(Duration timeout) async {
    try {
      final bloc = context.read<UserBloc>();
      if (bloc.state is UserLogged) return bloc.state as UserLogged;
      return await bloc.stream
          .where((s) => s is UserLogged)
          .cast<UserLogged>()
          .first
          .timeout(timeout);
    } catch (_) {
      return null;
    }
  }

  Future<List<CartItem>> _waitForCartItems(Duration timeout) async {
    try {
      final bloc = context.read<CartBloc>();
      final current = bloc.state.cart;
      if (current.isNotEmpty) return current;
      return await bloc.stream
          .where((s) => s.cart.isNotEmpty)
          .map((s) => s.cart)
          .first
          .timeout(timeout);
    } catch (_) {
      return context.read<CartBloc>().state.cart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderAddCubit, OrderAddState>(
      listener: (context, state) {
        if (state is OrderAddLoading) {
          EasyLoading.show(status: 'Placing order...');
        } else if (state is OrderAddSuccess) {
          EasyLoading.dismiss();
          context.read<CartBloc>().add(const ClearCart());
          context.go(NewWebRouter.newOrders);
          EasyLoading.showSuccess('Order placed');
        } else if (state is OrderAddFail) {
          EasyLoading.dismiss();
          EasyLoading.showError('Failed to place order');
          context.go(NewWebRouter.checkoutv2);
        }
      },
      child: Theme(
        data: QiratTheme.darkTheme,
        child: const Scaffold(
          backgroundColor: QiratTheme.darkBackground,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: QiratTheme.qiratGold),
                SizedBox(height: 12),
                Text('Finalizing your payment...',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
