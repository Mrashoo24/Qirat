import 'package:eshop/core/router/new_web_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/qirat_theme.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';
import '../../../../core/extension/string_extension.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/util/cartCalc.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../../domain/entities/order/order_details.dart';
import '../../../../domain/entities/order/order_item.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/home/navbar_cubit.dart';
import '../../../blocs/order/order_add/order_add_cubit.dart';
import '../../../widgets/input_form_button.dart';
import '../../../widgets/outline_label_card.dart';
import '../../../../core/services/services_locator.dart' as di;

class NewWebCheckoutView extends StatelessWidget {
  final List<CartItem> items;
  const NewWebCheckoutView({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: BlocProvider(
        create: (_) => di.sl<OrderAddCubit>(),
        child: BlocListener<OrderAddCubit, OrderAddState>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state is OrderAddLoading) {
              EasyLoading.show(status: 'Loading...');
            } else if (state is OrderAddSuccess) {
              // Keep legacy behavior
              try {
                context.read<NavbarCubit>().update(0);
                context.read<NavbarCubit>().controller.jumpToPage(0);
              } catch (_) {}
              context.read<CartBloc>().add(const ClearCart());
              Navigator.of(context).pop();
              EasyLoading.showSuccess('Order Placed Successfully');
            } else if (state is OrderAddFail) {
              EasyLoading.showError('Error');
            }
          },
          child: Scaffold(
            backgroundColor: QiratTheme.darkBackground,
            appBar: const QiratHeaderWidget(showShadow: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  // final List<CartItem> items = cartState.cart;

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 12),

                      // Delivery details
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: OutlineLabelCard(
                              title: 'Delivery Details',
                              child: BlocBuilder<UserBloc, UserState>(
                                builder: (context, state) {
                                  if (state is UserLogged) {
                                    final selected =
                                        state.user.deliveryInfos.firstWhere(
                                      (e) => e.isSelected,
                                      orElse: () =>
                                          state.user.deliveryInfos.first,
                                    );

                                    if (selected.isSelected) {
                                      return Container(
                                        padding: const EdgeInsets.only(
                                          top: 16,
                                          bottom: 12,
                                          left: 4,
                                          right: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${selected.firstName.capitalize()} ${selected.lastName}, ${selected.contactNumber}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${selected.addressLineOne}, ${selected.addressLineTwo}, ${selected.city}, ${selected.zipCode}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return Container(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 8,
                                      left: 4,
                                    ),
                                    child: const Text(
                                      'Please select delivery information',
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: -4,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                context.push(NewWebRouter.newDeliveryInfo);
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Selected products
                      OutlineLabelCard(
                        title: 'Selected Products',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18, bottom: 8),
                          child: Column(
                            children: items
                                .map(
                                  (product) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 75,
                                          child: AspectRatio(
                                            aspectRatio: 0.88,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: product.product
                                                          .images.isNotEmpty
                                                      ? product
                                                          .product.images.first
                                                      : '',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.product.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Quantity: ${product.quantity}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Unit Rate: ₹${product.priceTag.price.toStringAsFixed(2)}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Order summary
                      OutlineLabelCard(
                        title: 'Order Summery',
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Number of Items'),
                                  Text('x${items.length}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Price'),
                                  Text('₹${CartCalculator.getTotal(items)}')
                                ],
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Charge'),
                                  Text('₹0.00')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total'),
                                  Text('₹${CartCalculator.getTotal(items)}'),
                                ],
                              ),
                              Text(
                                ' Including Tax ₹${CartCalculator.getTotalWithoutTax(CartCalculator.getTotal(items)).toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Builder(
                  builder: (context) {
                    return InputFormButton(
                      color: Colors.black87,
                      onClick: () {
                        final currentState = context.read<UserBloc>().state;
                        if (currentState is UserLogged) {
                          final selectedInfos = currentState.user.deliveryInfos
                              .where((e) => e.isSelected);
                          if (selectedInfos.isNotEmpty) {
                            context.push(NewWebRouter.checkoutv2);
                            // context.read<OrderAddCubit>().addOrder(
                            //       OrderDetails(
                            //         id: '',
                            //         orderItems: items
                            //             .map(
                            //               (item) => OrderItem(
                            //                 id: '',
                            //                 product: item.product,
                            //                 priceTag: item.priceTag,
                            //                 price: item.priceTag.price,
                            //                 quantity: item.quantity,
                            //               ),
                            //             )
                            //             .toList(),
                            //         deliveryInfo: selectedInfos.first,
                            //         discount: 0,
                            //         uid: currentState.user.id,
                            //         total: CartCalculator.getTotal(items),
                            //         status: statuesPending,
                            //         info: '',
                            //         date: DateTime.now()
                            //             .toString()
                            //             .split('.')
                            //             .first,
                            //       ),
                            //     );
                          } else {
                            EasyLoading.showError(
                              'Error \nPlease select delivery add your delivery information',
                            );
                          }
                        } else {
                          EasyLoading.showError(
                            'Error \nPlease select delivery add your delivery information',
                          );
                        }
                      },
                      titleText: 'Confirm',
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
