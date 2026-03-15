// ...existing code...
import 'dart:convert';
import 'package:eshop/core/router/new_web_router.dart';
import 'package:eshop/domain/entities/user/delivery_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
// Removed unused imports that may not exist in current plugin version

import '../../../../core/theme/qirat_theme.dart';
// import '../../../../core/router/app_router.dart';
import '../../../../core/util/cartCalc.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../../domain/usecases/payment/create_cashfree_order_usecase.dart';
import '../../../../domain/entities/order/order_details.dart';
import '../../../../domain/entities/order/order_item.dart';
import '../../../../core/constant/strings.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/order/order_add/order_add_cubit.dart';
import '../../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../../core/analytics/app_analytics.dart';

class CheckoutViewV2 extends StatefulWidget {
  final List<CartItem>? checkoutItems;
  final String source;
  const CheckoutViewV2({
    Key? key,
    this.checkoutItems,
    this.source = 'cart',
  }) : super(key: key);

  @override
  State<CheckoutViewV2> createState() => _CheckoutViewV2State();
}

enum _PayMode { cod, online }

class _CheckoutViewV2State extends State<CheckoutViewV2> {
  _PayMode _mode = _PayMode.cod;
  var cfPaymentGatewayService = CFPaymentGatewayService();
  List<CartItem>? _pendingItems;
  String? _pendingUid;
  DeliveryInfo? _selectedInfos;

  String get _paymentMethodName => _mode == _PayMode.cod ? 'cod' : 'online';

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(_onPaymentVerified, _onPaymentError);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderAddCubit>(),
      child: BlocListener<OrderAddCubit, OrderAddState>(
        listener: (context, state) {
          EasyLoading.dismiss();
          print('state == ${state.toString()}');
          final itemCount =
              _effectiveItems(context.read<CartBloc>().state).length;
          if (state is OrderAddLoading) {
            EasyLoading.show(status: 'Placing order...');
          } else if (state is OrderAddSuccess) {
            AppAnalytics.logOrderPlacedSuccess(
              paymentMethod: _paymentMethodName,
              itemCount: itemCount,
              source: widget.source,
            );
            if (widget.source != 'buy_now') {
              context.read<CartBloc>().add(const ClearCart());
            }
            context.go(
              NewWebRouter.newOrders,
            );
            EasyLoading.showSuccess('Order placed');
          } else if (state is OrderAddFail) {
            AppAnalytics.logOrderPlacedFailed(
              paymentMethod: _paymentMethodName,
              itemCount: itemCount,
              source: widget.source,
              reason: 'order_add_failed',
            );
            EasyLoading.showError('Failed to place order');
          }
        },
        child: Theme(
          data: QiratTheme.darkTheme,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Checkout'),
              backgroundColor: QiratTheme.darkSurface,
            ),
            backgroundColor: QiratTheme.darkBackground,
            body: _buildBody(context),
            bottomNavigationBar: _buildBottomBar(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final items = _effectiveItems(cartState);
        final total = CartCalculator.getTotal(items);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: QiratTheme.darkSurface,
                border: Border.all(color: QiratTheme.goldBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Payment Method',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  SegmentedButton<_PayMode>(
                    segments: const [
                      ButtonSegment(value: _PayMode.cod, label: Text('COD')),
                      ButtonSegment(
                          value: _PayMode.online, label: Text('Online')),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (s) {
                      final selectedMode = s.first;
                      setState(() => _mode = selectedMode);
                      AppAnalytics.logPaymentMethodSelected(
                        paymentMethod:
                            selectedMode == _PayMode.cod ? 'cod' : 'online',
                        source: widget.source,
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          QiratTheme.darkSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: QiratTheme.darkSurface,
                border: Border.all(color: QiratTheme.goldBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Summary',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...items.map((i) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${i.product.name} • ${i.priceTag.name} × ${i.quantity}',
                              style: const TextStyle(
                                  color: QiratTheme.textSecondary,
                                  fontFamily: 'Inter'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                              '₹${(i.priceTag.price * i.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: QiratTheme.qiratGold,
                                  fontFamily: 'Inter')),
                        ],
                      )),
                  const Divider(color: QiratTheme.borderDark),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Total',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold)),
                      ),
                      Text('₹$total',
                          style: const TextStyle(
                              color: QiratTheme.qiratGold,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: QiratTheme.darkSurface,
                border: Border.all(color: QiratTheme.goldBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child:
                  BlocBuilder<DeliveryInfoFetchCubit, DeliveryInfoFetchState>(
                builder: (context, diState) {
                  final currentState = context.read<UserBloc>().state;
                  if (currentState is UserLogged) {
                    final selected = currentState.user.deliveryInfos
                        .where((e) => e.isSelected);

                    if (selected.isEmpty) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Deliver To',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 6),
                          Text(
                            'Please add/select a delivery address',
                            style: TextStyle(
                                color: QiratTheme.textSecondary,
                                fontFamily: 'Inter'),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Deliver To',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                          '${selected.first.firstName} ${selected.first.lastName}, ${selected.first.contactNumber}',
                          style: const TextStyle(
                              color: QiratTheme.textSecondary,
                              fontFamily: 'Inter'),
                        ),
                        Text(
                          '${selected.first.addressLineOne}, ${selected.first.addressLineTwo}, ${selected.first.city}, ${selected.first.zipCode}',
                          style: const TextStyle(
                              color: QiratTheme.textSecondary,
                              fontFamily: 'Inter'),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final items = _effectiveItems(cartState);
        final total = CartCalculator.getTotal(items).toDouble();

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: const BoxDecoration(
                color: QiratTheme.darkSurface,
                border: Border(top: BorderSide(color: QiratTheme.goldBorder))),
            child: Row(
              children: [
                Expanded(
                  child: Text('Payable: ₹$total',
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('clicked');
                    AppAnalytics.logOrderConfirmClicked(
                      paymentMethod: _paymentMethodName,
                      itemCount: items.length,
                      source: widget.source,
                    );
                    _onConfirm(context, items, total);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onConfirm(
      BuildContext context, List<CartItem> items, double total) async {
    final userState = context.read<UserBloc>().state;
    if (userState is! UserLogged) {
      AppAnalytics.logAuthRequired(flow: 'checkout_payment');
      context.pushNamed(
        NewWebRouter.newSignIn,
        extra: {
          'flow': 'checkout',
          'source': widget.source,
          'nextRoute': NewWebRouter.checkoutv2,
          'requiresDelivery': true,
          'items': items,
        },
      );
      return;
    }

    final selectedInfos =
        userState.user.deliveryInfos.where((e) => e.isSelected);

    if (selectedInfos.isEmpty) {
      context.push(
        NewWebRouter.newDeliveryInfo,
        extra: {
          'flow': 'checkout',
          'source': widget.source,
          'nextRoute': NewWebRouter.checkoutv2,
          'items': items,
        },
      );
      return;
    }

    if (_mode == _PayMode.cod) {
      _placeOrder(
          context, items, userState.user.id, 'COD', selectedInfos.first);
      return;
    }

    // if (!Platform.isAndroid && !Platform.isIOS) {
    //   EasyLoading.showError('Online payment not supported on this platform');
    //   return;
    // }

    try {
      EasyLoading.show(status: 'Starting payment...');
      final usecase = sl<CreateCashfreeOrderUseCase>();
      final res = await usecase(Params(
        customerId: userState.user.id,
        customerName: '${userState.user.firstName} ${userState.user.lastName}',
        customerPhone: selectedInfos.first.contactNumber,
        customerEmail: userState.user.email,
        amount: total,
        // Web needs a return URL page; include order_id placeholder per Cashfree docs
        returnUrl: const String.fromEnvironment(
          'CHECKOUT_RETURN_URL',
          defaultValue: '${kdomainurl}/payment-return?order_id={order_id}',
        ),
        meta: {
          'cart_size': items.length,
        },
      ));

      await res.fold((_) async {
        AppAnalytics.logOrderPlacedFailed(
          paymentMethod: _paymentMethodName,
          itemCount: items.length,
          source: widget.source,
          reason: 'payment_init_failed',
        );
        EasyLoading.dismiss();
        EasyLoading.showError('Failed to init payment');
      }, (cfOrder) async {
        var session = CFSessionBuilder()
            .setEnvironment(CFEnvironment.PRODUCTION)
            .setOrderId(cfOrder.orderId)
            .setPaymentSessionId(cfOrder.paymentSessionId)
            .build();

        // Use CF Web Checkout (Drop Checkout is deprecated)
        final webCheckout =
            CFWebCheckoutPaymentBuilder().setSession(session).build();

        // Keep snapshot for callback
        _pendingItems = items.map((e) => e).toList();
        _pendingUid = userState.user.id;
        _selectedInfos = selectedInfos.first;

        EasyLoading.show(status: 'Opening payment...');
        // Trigger payment; results will arrive via callbacks
        await cfPaymentGatewayService.doPayment(webCheckout);
        // Loader will be dismissed in callbacks
      });
    } catch (e) {
      AppAnalytics.logOrderPlacedFailed(
        paymentMethod: _paymentMethodName,
        itemCount: items.length,
        source: widget.source,
        reason: 'payment_exception',
      );
      EasyLoading.dismiss();
      EasyLoading.showError('Payment error');
    }
  }

  void _onPaymentVerified(String orderId) {
    final items = _pendingItems;
    final uid = _pendingUid;
    final selectedInfos = _selectedInfos;

    if (items == null || uid == null || selectedInfos == null) {
      EasyLoading.dismiss();
      EasyLoading.showError('Order context missing');
      return;
    }

    () async {
      EasyLoading.show(status: 'Verifying payment...');
      final verified = await _verifyPaymentWithServer(orderId);
      EasyLoading.dismiss();
      final info =
          verified ? 'ONLINE:SUCCESS ($orderId)' : 'ONLINE:PENDING ($orderId)';
      _placeOrder(context, items, uid, info, selectedInfos);
      _pendingItems = null;
      _pendingUid = null;
      _selectedInfos = null;
    }();
  }

  void _onPaymentError(CFErrorResponse errorResponse, String orderId) {
    final itemCount = _pendingItems?.length ?? 0;
    AppAnalytics.logOrderPlacedFailed(
      paymentMethod: 'online',
      itemCount: itemCount,
      source: widget.source,
      reason: errorResponse.getMessage() ?? 'payment_failed',
    );
    EasyLoading.dismiss();
    final msg = errorResponse.getMessage() ?? 'Payment failed';
    EasyLoading.showError(msg);
    _pendingItems = null;
    _pendingUid = null;
  }

  void _placeOrder(BuildContext context, List<CartItem> items, String uid,
      String info, DeliveryInfo delInfo) {
    context.read<OrderAddCubit>().addOrder(OrderDetails(
          id: '',
          orderItems: items
              .map((i) => OrderItem(
                    id: '',
                    product: i.product,
                    priceTag: i.priceTag,
                    price: i.priceTag.price,
                    quantity: i.quantity,
                  ))
              .toList(),
          deliveryInfo: delInfo,
          discount: 0,
          uid: uid,
          total: CartCalculator.getTotal(items),
          status: statuesPending,
          info: info,
          date: DateTime.now().toString().split('.').first,
        ));
  }

  Future<bool> _verifyPaymentWithServer(String orderId) async {
    const baseUrl = kbaseurl;
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

  List<CartItem> _effectiveItems(CartState cartState) {
    if (widget.checkoutItems != null && widget.checkoutItems!.isNotEmpty) {
      return widget.checkoutItems!;
    }
    return cartState.cart;
  }
}
